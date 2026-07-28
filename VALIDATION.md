# Validation report

## Completed in the generation sandbox

- Parsed **128** TypeScript/TSX files with the TypeScript 5.8 compiler parser: **0 syntax errors**.
- Checked every `@/…` import against the generated source tree: **0 unresolved internal imports**.
- Checked the Prisma schema against the initial SQL migration: **33 models, 33 tables, no missing or extra tables**.
- Parsed all local SVG assets as XML: **0 XML errors**.
- Verified **24 product SVG files with 24 unique SHA-256 hashes** for 12 products.
- Rendered the 12 detail SVGs during validation to confirm the bouquet/plant artwork is visible and materially different after removing unsupported SVG filter effects.
- Executed standalone logic checks for:
  - multi-turn Flora recommendations and ambiguous numeric replies,
  - server price calculation with variants, add-ons, gift wrap, tax, delivery, and coupon,
  - signed demo-payment verification and tamper rejection.
- Counted **46 API route files** covering authentication, catalogue, carts, addresses, orders, payments, delivery, location, uploads, chat, and administration.

## Limitation of this environment

The sandbox package registry returned HTTP 503/timeouts, so dependencies could not be downloaded. Consequently, these commands could not be executed here:

```bash
npm install
npm run db:generate
npm run typecheck
npm run test
npm run build
```

Run them on a networked machine before deployment. This report does not claim that live third-party services work without credentials. Razorpay, Google Places/Geocoding, SMTP, Cloudinary, Supabase Realtime, and hosted PostgreSQL require valid environment variables.
