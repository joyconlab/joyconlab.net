interface ContactCardProps {
  icon: string;
  title: string;
  content: string;
  href?: string;
  isExternal?: boolean;
  index: number;
}

export default function ContactCard({ icon, title, content, href, isExternal, index }: ContactCardProps) {
  const cardContent = (
    <>
      <div className="contact-icon">{icon}</div>
      <h3>{title}</h3>
      <p>{content}</p>
      {href && <span className="arrow">→</span>}
    </>
  );

  if (href) {
    return (
      <a 
        href={href} 
        className={`contact-card fade-in stagger-${index + 1}`}
        {...(isExternal && { target: '_blank', rel: 'noopener noreferrer' })}
      >
        {cardContent}
      </a>
    );
  }

  return (
    <div className={`contact-card fade-in stagger-${index + 1}`}>
      {cardContent}
    </div>
  );
}
