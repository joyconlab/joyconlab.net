interface ServiceCardProps {
  icon: string;
  title: string;
  description: string;
  features: string[];
  index: number;
}

export default function ServiceCard({ icon, title, description, features, index }: ServiceCardProps) {
  return (
    <article className={`service-card fade-in stagger-${Math.min(index + 1, 6)}`}>
      <div className="service-icon">{icon}</div>
      <h3>{title}</h3>
      <p>{description}</p>
      <ul>
        {features.map((feature, i) => (
          <li key={i}>{feature}</li>
        ))}
      </ul>
    </article>
  );
}
