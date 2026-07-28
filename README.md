# Petalora Rebuilt

A clean, modular full-stack flower marketplace and delivery application built from scratch with Next.js, TypeScript, Tailwind CSS, Prisma, PostgreSQL, Razorpay, browser GPS, OpenStreetMap/Leaflet, optional Google Places, optional Supabase Realtime, and a product-aware flower concierge.

## App Router structure

This edition uses the Next.js App Router at the project root (`app/`). Reusable code remains under `src/`. The ZIP is flattened: `package.json`, `app/`, `src/`, and `prisma/` are all in the same project root.

On Windows, double-click `start-windows.bat`, or run `npm install` followed by `npm run dev`. The local address is `http://localhost:3000`.

## What was rebuilt

This version specifically fixes the failures visible in the earlier prototype:

- **Every product has its own local artwork.** The 12 catalogue items use 24 distinct SVG assets under `public/products`; unrelated stock photographs and duplicate image URLs are not used. The assets were XML-validated and render-checked, and unsupported SVG filter effects were removed so image optimizers do not produce blank cards.
- **Checkout cannot silently fail because the visitor is logged out.** `/checkout` redirects to login first and returns to checkout afterward.
- **Payments work without paid credentials.** `PAYMENT_MODE=demo` presents a real test checkout flow with server-signed demo tokens, success/failure simulation, order creation, and server verification. Switching to Razorpay test/live mode requires only environment variables.
- **Map selection works without a Google key.** Leaflet and OpenStreetMap provide click-to-pin mapping, browser geolocation, and coordinate persistence. Google Places and Google reverse geocoding activate when keys are supplied.
- **Flora is multi-turn and product-aware.** It asks follow-up questions, handles ambiguous replies such as `2`, extracts budget/occasion/colour, and recommends actual catalogue items instead of repeating a fixed paragraph. In PostgreSQL mode it reads the active database catalogue.
- **Tracking works in local demo mode.** Delivery partners can accept an order, share browser GPS every 10–15 seconds, update order stages, and complete delivery with OTP `2468`. Customer tracking polls every 10 seconds and uses Supabase broadcasts when configured.

## Stack

- Next.js 14 App Router and TypeScript
- Tailwind CSS and reusable shadcn-style UI primitives
- PostgreSQL and Prisma
- Secure HMAC/JWT cookie sessions with scrypt password hashing
- Razorpay SDK plus a fully working signed demo gateway
- Leaflet/OpenStreetMap with optional Google Places and Google Geocoding
- Optional Supabase Realtime with polling fallback
- Nodemailer, Cloudinary signed uploads, Zod validation, secure headers, and rate limiting

## Fastest local start: demo mode

Demo mode does not require PostgreSQL, Razorpay keys, Google keys, or an email server.

```powershell
cd petalora-rebuilt
Copy-Item .env.example .env.local
npm install
npm run dev
```

On macOS/Linux:

```bash
cd petalora-rebuilt
cp .env.example .env.local
npm install
npm run dev
```

Open `http://localhost:3000`.

Do not open VS Code's browser debugger until the terminal prints `Ready`. The Next.js development port is **3000**, not 8080.


## VS Code one-key start

Open the `petalora-rebuilt` folder itself, then press **F5** and select **Petalora: start dev server**. The included `.vscode/launch.json` runs `npm run dev` and opens the detected Next.js URL. See `START-HERE.md` for Windows instructions.

## Demo accounts

| Role | Email | Password |
|---|---|---|
| Customer | `customer@petalora.test` | `Customer123!` |
| Admin | `admin@petalora.test` | `Admin123!` |
| Vendor | `vendor@petalora.test` | `Vendor123!` |
| Delivery partner | `delivery@petalora.test` | `Delivery123!` |

Delivery OTP: `2468`

The login page includes one-click buttons for each role.

## Demo payment test

1. Sign in as the customer.
2. Add a product and go to checkout.
3. Complete the receiver address or use **Use my location**.
4. Keep **Online payment** selected.
5. Click Pay.
6. Choose **Simulate successful payment** or **Simulate failed payment**.

The demo token is HMAC-signed on the server. The amount is recalculated from product IDs and variants on the server, so changing browser totals cannot change the charged order amount.

## Razorpay test mode

Create Razorpay test credentials, then set:

```env
PAYMENT_MODE=razorpay
RAZORPAY_KEY_ID=rzp_test_...
RAZORPAY_KEY_SECRET=...
RAZORPAY_WEBHOOK_SECRET=...
NEXT_PUBLIC_RAZORPAY_KEY_ID=rzp_test_...
```

Restart the server. Configure the webhook URL:

```text
https://YOUR_DOMAIN/api/payments/razorpay/webhook
```

Handled events:

- `payment.captured`
- `payment.failed`
- `refund.processed`

The secret is never sent to the browser. Only the key ID, provider order ID, amount, and currency are returned to Razorpay Checkout.

## Location and maps

The default map is functional without a key:

- Click anywhere to place a delivery pin.
- Press **Use my location** to request browser GPS permission.
- The selected latitude and longitude are stored with the order.
- Reverse geocoding uses Google when `GOOGLE_MAPS_SERVER_KEY` exists, otherwise it tries OpenStreetMap Nominatim.

Optional Google enhancements:

```env
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=...
GOOGLE_MAPS_SERVER_KEY=...
```

Enable Maps JavaScript API, Places API, and Geocoding API in the Google Cloud project. Restrict the browser key by HTTP referrer and the server key by deployment IP/API.

Browser location only works on secure origins (`https://`) or `localhost`. It does not continue after the browser or tab is closed. The delivery APIs are ready to be reused by a later React Native or Flutter app for real background GPS.

## PostgreSQL production mode

Start local PostgreSQL with Docker:

```bash
docker compose up -d db
```

Set in `.env.local`:

```env
DEMO_MODE=false
NEXT_PUBLIC_DEMO_MODE=false
DATABASE_URL=postgresql://petalora:petalora@localhost:5432/petalora?schema=public
```

Then run:

```bash
npm run db:generate
npm run db:deploy
npm run db:seed
npm run dev
```

The seed creates:

- 12 unique products and multiple variants
- 7 categories
- 3 approved vendors
- 3 delivery partners
- 5 customer accounts
- demo coupons and reviews
- sample orders at different stages

## Supabase/Neon

1. Create a PostgreSQL project in Supabase or Neon.
2. Copy its pooled database URL into `DATABASE_URL`.
3. Run `npm run db:deploy` and `npm run db:seed` from a secure machine or deployment job.
4. For Supabase Realtime broadcasts, add:

```env
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
```

Polling remains active if realtime is not configured.

## Google OAuth

Set:

```env
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
```

Register this redirect URI:

```text
http://localhost:3000/api/auth/google/callback
```

Use the deployed domain in production.

## Email and uploads

Email preview logs are used when `EMAIL_SERVER` is blank. For SMTP:

```env
EMAIL_SERVER=smtps://USERNAME:PASSWORD@HOST:465
EMAIL_FROM=Petalora <orders@example.com>
```

For Cloudinary signed product uploads:

```env
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
```

Request a signed upload payload from `POST /api/uploads/cloudinary/sign`. Client upload forms should enforce the returned 5 MB limit and image formats.

## Commands

```bash
npm run dev
npm run typecheck
npm run lint
npm run test
npm run build
npm run db:generate
npm run db:migrate
npm run db:deploy
npm run db:seed
```

## Important API routes

- Authentication: `/api/auth/login`, `/register`, `/logout`, `/forgot-password`, `/reset-password`, `/google`
- Products and categories: `/api/products`, `/api/products/:id`, `/api/categories`
- Cart and addresses: `/api/cart`, `/api/cart/items`, `/api/addresses`
- Orders: `/api/orders`, `/api/orders/:id`, `/api/orders/:id/status`, `/cancel`
- Payment: `/api/payments/razorpay/create-order`, `/verify`, `/webhook`, `/api/payments/:id/refund`
- Delivery: `/api/delivery/assign`, `/accept`, `/reject`, `/status`, `/location`, `/verify-otp`
- Admin: `/api/admin/dashboard`, `/orders`, `/users`, `/vendors`, `/delivery-partners`, `/orders/export`
- AI concierge: `/api/chat`
- Location: `/api/location/reverse`, `/api/serviceability`

## Deployment to Vercel

1. Push the project to GitHub.
2. Import it in Vercel.
3. Add production environment variables.
4. Use a hosted PostgreSQL `DATABASE_URL` and set `DEMO_MODE=false`.
5. Run migrations before or during deployment with `npm run db:deploy`.
6. Deploy.
7. Add the production Razorpay webhook and Google OAuth callback URLs.

The file-backed demo store is for local development only. Vercel's filesystem is ephemeral, so production must use PostgreSQL.
