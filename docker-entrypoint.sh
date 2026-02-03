#!/bin/sh
set -e

echo "🔄 Applying Prisma schema to database..."
npx prisma db push --accept-data-loss --skip-generate || true

echo "✅ Schema applied"
echo "🚀 Starting Next.js application..."
exec npm start
