import { useEffect, useState } from 'react';

export default function PageLoader() {
  const [hidden, setHidden] = useState(true);
  const [shouldRender, setShouldRender] = useState(false);

  useEffect(() => {
    const alreadyShown = sessionStorage.getItem('loaderShown');
    
    if (alreadyShown) {
      setShouldRender(false);
      return;
    }

    setShouldRender(true);
    setHidden(false);

    const timer = setTimeout(() => {
      setHidden(true);
      sessionStorage.setItem('loaderShown', 'true');
    }, 1200);

    return () => clearTimeout(timer);
  }, []);

  if (!shouldRender) return null;

  return (
    <div className={`page-loader ${hidden ? 'hidden' : ''}`}>
      <div className="loader-content">
        <div className="loader-logo">
          <span className="joy">JOY</span>
          <span className="con">-CON</span>{' '}
          <span className="lab">LAB</span>
        </div>
        <div className="loader-bar">
          <div className="loader-progress" />
        </div>
      </div>
    </div>
  );
}
