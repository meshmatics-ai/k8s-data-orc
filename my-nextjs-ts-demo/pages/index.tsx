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
