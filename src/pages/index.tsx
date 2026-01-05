import { useSession, signIn, signOut } from "next-auth/react";
import { prisma } from "../lib/prisma";

export default function Home({ paragraphs }) {
  const { data: session } = useSession();

  return (
    <div style={{ padding: '20px', fontFamily: 'serif' }}>
      <h1>Ciencia y Religión - Análisis Social</h1>
      {!session ? (
        <button onClick={() => signIn('google')}>Login con Google para comentar</button>
      ) : (
        <button onClick={() => signOut()}>Salir ({session.user.name})</button>
      )}

      {paragraphs.map(p => (
        <div key={p.id} style={{ borderBottom: '1px solid #ccc', margin: '20px 0' }}>
          <p>{p.content}</p>
          <small>{p.comments.length} comentarios</small>
          {session && (
            <textarea placeholder="Escribe tu análisis sobre este párrafo..." />
          )}
        </div>
      ))}
    </div>
  );
}

export async function getServerSideProps() {
  try {
    const paragraphs = await prisma.paragraph.findMany({
      include: {
        comments: {
          include: {
            user: true,
          },
        },
      },
    });

    return {
      props: {
        paragraphs: JSON.parse(JSON.stringify(paragraphs)),
      },
    };
  } catch (error) {
    console.error("Error fetching paragraphs:", error);
    return {
      props: {
        paragraphs: [],
      },
    };
  }
}