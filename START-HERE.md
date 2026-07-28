# Start Petalora on Windows
## Important: open the correct folder

Open the folder that directly contains `package.json` and the root `app/` directory. This download has been flattened, so there is no second nested `petalora-rebuilt` folder.

The application uses the Next.js App Router in `app/`, and runs at **http://localhost:3000**. Do not use port 8080.

You can also double-click `start-windows.bat`.

1. Extract the ZIP.
2. In VS Code choose **File → Open Folder** and select the **petalora-rebuilt** folder itself.
3. Open **Terminal → New Terminal**.
4. Run:

```powershell
Copy-Item .env.example .env.local
npm install
npm run dev
```

5. Wait for Next.js to print `Ready`, then open `http://localhost:3000`.

You may also press **F5** and choose **Petalora: Run App Router on port 3000**. The included launch configuration starts Next.js and opens the detected local URL. Do not use port 8080.

## First login

Use the one-click **Customer** demo login, or enter:

- Email: `customer@petalora.test`
- Password: `Customer123!`

## Test checkout

Keep `PAYMENT_MODE=demo` in `.env.local`. Add a product, sign in, complete the address, choose online payment, and select **Simulate successful payment**. No bank account or API key is needed.

## Real services

The keyless demo map, browser GPS, local AI concierge, signed demo payment flow, demo order tracking, and role dashboards work without paid credentials. Live Razorpay, Google Places, SMTP, Cloudinary, Supabase Realtime, and PostgreSQL activate only after their environment variables are configured; see `README.md`.
