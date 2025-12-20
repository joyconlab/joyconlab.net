import { useEffect, useRef } from 'react';
import type { ReactNode } from 'react';

interface AnimatedSectionProps {
  children: ReactNode;
  className?: string;
}

export default function AnimatedSection({ children, className = '' }: AnimatedSectionProps) {
  const sectionRef = useRef<HTMLDivElement>(null);
  const observerRef = useRef<IntersectionObserver | null>(null);

  const setupObserver = () => {
    if (observerRef.current) {
      observerRef.current.disconnect();
    }

    observerRef.current = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            
            if (entry.target.classList.contains('stat')) {
              const numEl = entry.target.querySelector('.stat-number') as HTMLElement;
              if (numEl?.dataset.count && !numEl.dataset.animated) {
                numEl.dataset.animated = 'true';
                animateNumber(numEl, parseInt(numEl.dataset.count), numEl.dataset.suffix || '');
              }
            }
          }
        });
      },
      { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }
    );

    if (sectionRef.current) {
      const elements = sectionRef.current.querySelectorAll(
        '.fade-in, .fade-in-left, .fade-in-right, .scale-in, .stat'
      );
      elements.forEach(el => {
        el.classList.remove('visible');
        observerRef.current?.observe(el);
      });
    }
  };

  useEffect(() => {
    setupObserver();

    const handlePageLoad = () => {
      setTimeout(setupObserver, 100);
    };

    document.addEventListener('astro:page-load', handlePageLoad);

    return () => {
      observerRef.current?.disconnect();
      document.removeEventListener('astro:page-load', handlePageLoad);
    };
  }, []);

  const animateNumber = (el: HTMLElement, target: number, suffix: string) => {
    let current = 0;
    const duration = 2000;
    const increment = target / (duration / 16);
    
    const timer = setInterval(() => {
      current += increment;
      if (current >= target) {
        el.textContent = target + suffix;
        clearInterval(timer);
      } else {
        el.textContent = Math.floor(current).toString();
      }
    }, 16);
  };

  return (
    <div ref={sectionRef} className={className}>
      {children}
    </div>
  );
}
