#!/bin/sh
set -e

echo "🔄 Running Prisma migrations..."
npx prisma migrate deploy || npx prisma db push --skip-generate

echo "✅ Migrations completed"
echo "🚀 Starting Next.js application..."
exec npm start
