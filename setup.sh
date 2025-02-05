
#!/usr/bin/env bash

# -------------------------------------------------------------
# Script: create_nextjs_ts_demo.sh
# Purpose: Creates a minimal Next.js (TypeScript) project with
#          polling for prompt-answer data using Axios.
# Usage:   chmod +x create_nextjs_ts_demo.sh && ./create_nextjs_ts_demo.sh
# -------------------------------------------------------------

# 1) Create a project folder
PROJECT_NAME="my-nextjs-ts-demo"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit 1

echo "Creating Next.js TypeScript project: $PROJECT_NAME"

# 2) Initialize package.json
cat << 'EOF' > package.json
{
  "name": "my-nextjs-ts-demo",
  "version": "0.1.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "axios": "^1.3.0",
    "next": "^13.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "typescript": "^4.7.4"
  }
}
EOF

# 3) Create a basic tsconfig.json
cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "es2020",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "preserve"
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF

# 4) Create a minimal next.config.js
cat << 'EOF' > next.config.js
/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true
}
EOF

# 5) Create the pages/ directory and subdirectories
mkdir -p pages/api

# 6) Create an optional sample API route
cat << 'EOF' > pages/api/hello.ts
import type { NextApiRequest, NextApiResponse } from 'next'

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  res.status(200).json({ message: 'Hello from Next.js API route!' });
}
EOF

# 7) Create the main page: pages/index.tsx
cat << 'EOF' > pages/index.tsx
import { useEffect, useState } from 'react';
import axios from 'axios';

interface Exchange {
  prompt: string;
  answer: string;
  timestamp: string;
}

export default function Home() {
  const [exchanges, setExchanges] = useState<Exchange[]>([]);

  useEffect(() => {
    // Poll the prompt-answers service every 3s
    const interval = setInterval(() => {
      axios.get<Exchange[]>('http://prompt-answers.my-demo.com/api/exchanges')
        .then((response) => setExchanges(response.data))
        .catch((err) => console.error('Failed to fetch exchanges:', err));
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  return (
    <main style={{ padding: '2rem', fontFamily: 'sans-serif' }}>
      <h1 style={{ fontSize: '1.8rem', marginBottom: '1rem' }}>
        Prompt-Answer Monitoring Demo
      </h1>
      <section style={{ maxHeight: '300px', overflowY: 'auto', border: '1px solid #ccc', padding: '1rem' }}>
        {exchanges.length === 0 ? (
          <p>No exchanges yet...</p>
        ) : (
          exchanges.map((ex, i) => (
            <div key={i} style={{ marginBottom: '1rem', padding: '0.5rem', borderBottom: '1px solid #ddd' }}>
              <p style={{ fontSize: '0.9rem', color: '#666' }}>{ex.timestamp}</p>
              <p><strong>Prompt:</strong> {ex.prompt}</p>
              <p><strong>Answer:</strong> {ex.answer}</p>
            </div>
          ))
        )}
      </section>
    </main>
  );
}
EOF

# 8) Install dependencies
echo "Installing dependencies..."
npm install

# 9) Print instructions
echo ""
echo "✅ Project setup complete!"
echo "Next steps:"
echo "  1) cd $PROJECT_NAME"
echo "  2) npm run dev (or npm run build && npm start)"
echo "  3) Open http://localhost:3000 to see your Next.js app."
echo ""
echo "🎉 Happy hacking! Push this project to GitHub or Azure Repos when ready."
