# App Router location

This project uses the Next.js **App Router** at the project root:

```text
app/
├── layout.tsx
├── page.tsx
├── globals.css
├── api/
├── flowers/
├── cart/
├── checkout/
├── dashboard/
├── admin/
├── vendor/
└── delivery/
```

Next.js API route handlers are under `app/api/**/route.ts`.

The `src/` directory contains reusable components, services, data, hooks, utilities and types. The `app/` directory contains pages, layouts and route handlers.
