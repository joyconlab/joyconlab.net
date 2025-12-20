import { useEffect, useRef, useState } from 'react';

export default function Cursor() {
  const cursorRef = useRef<HTMLDivElement>(null);
  const [isHovering, setIsHovering] = useState(false);
  const mousePos = useRef({ x: 0, y: 0 });
  const cursorPos = useRef({ x: 0, y: 0 });
  const rafId = useRef<number>();

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      mousePos.current = { x: e.clientX, y: e.clientY };
    };

    const animateCursor = () => {
      cursorPos.current.x += (mousePos.current.x - cursorPos.current.x) * 0.15;
      cursorPos.current.y += (mousePos.current.y - cursorPos.current.y) * 0.15;
      
      if (cursorRef.current) {
        cursorRef.current.style.left = `${cursorPos.current.x}px`;
        cursorRef.current.style.top = `${cursorPos.current.y}px`;
      }
      
      rafId.current = requestAnimationFrame(animateCursor);
    };

    const addHoverListeners = () => {
      const interactiveElements = document.querySelectorAll('a, button, .service-card, .contact-card');
      interactiveElements.forEach(el => {
        el.addEventListener('mouseenter', () => setIsHovering(true));
        el.addEventListener('mouseleave', () => setIsHovering(false));
      });
    };

    document.addEventListener('mousemove', handleMouseMove);
    rafId.current = requestAnimationFrame(animateCursor);
    addHoverListeners();

    const handlePageLoad = () => {
      setTimeout(addHoverListeners, 100);
    };

    document.addEventListener('astro:page-load', handlePageLoad);

    return () => {
      document.removeEventListener('mousemove', handleMouseMove);
      document.removeEventListener('astro:page-load', handlePageLoad);
      if (rafId.current) cancelAnimationFrame(rafId.current);
    };
  }, []);

  return (
    <div 
      ref={cursorRef} 
      className={`cursor ${isHovering ? 'hover' : ''}`}
    />
  );
}
