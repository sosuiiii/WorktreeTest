class LiquidGlass {
    constructor() {
        this.container = document.querySelector('.liquid-glass');
        this.blobs = document.querySelectorAll('.liquid-blob');
        this.mouseX = 0;
        this.mouseY = 0;
        this.targetX = 0;
        this.targetY = 0;
        
        this.init();
    }
    
    init() {
        this.addEventListeners();
        this.createParticles();
        this.animate();
    }
    
    addEventListeners() {
        document.addEventListener('mousemove', (e) => {
            this.mouseX = e.clientX;
            this.mouseY = e.clientY;
            this.updateGlassPosition(e);
        });
        
        this.container.addEventListener('mouseenter', () => {
            this.container.style.transform = 'scale(1.05)';
        });
        
        this.container.addEventListener('mouseleave', () => {
            this.container.style.transform = 'scale(1)';
        });
    }
    
    updateGlassPosition(e) {
        const rect = this.container.getBoundingClientRect();
        const centerX = rect.left + rect.width / 2;
        const centerY = rect.top + rect.height / 2;
        
        const deltaX = (e.clientX - centerX) * 0.02;
        const deltaY = (e.clientY - centerY) * 0.02;
        
        this.targetX = deltaX;
        this.targetY = deltaY;
    }
    
    createParticles() {
        for (let i = 0; i < 20; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.cssText = `
                position: absolute;
                width: ${Math.random() * 4 + 2}px;
                height: ${Math.random() * 4 + 2}px;
                background: rgba(255, 255, 255, ${Math.random() * 0.5 + 0.2});
                border-radius: 50%;
                pointer-events: none;
                animation: particleFloat ${Math.random() * 10 + 15}s linear infinite;
                left: ${Math.random() * 100}%;
                top: ${Math.random() * 100}%;
                animation-delay: ${Math.random() * 10}s;
            `;
            this.container.appendChild(particle);
        }
        
        const style = document.createElement('style');
        style.textContent = `
            @keyframes particleFloat {
                0% {
                    transform: translateY(0) rotate(0deg);
                    opacity: 0;
                }
                10% {
                    opacity: 1;
                }
                90% {
                    opacity: 1;
                }
                100% {
                    transform: translateY(-400px) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    }
    
    animate() {
        this.blobs.forEach((blob, index) => {
            const speed = 0.02 + index * 0.01;
            const currentX = parseFloat(blob.style.transform?.match(/translateX\(([^)]+)\)/)?.[1] || 0);
            const currentY = parseFloat(blob.style.transform?.match(/translateY\(([^)]+)\)/)?.[1] || 0);
            
            const newX = currentX + (this.targetX * (1 + index * 0.5) - currentX) * speed;
            const newY = currentY + (this.targetY * (1 + index * 0.5) - currentY) * speed;
            
            blob.style.transform = `translateX(${newX}px) translateY(${newY}px) scale(${1 + Math.sin(Date.now() * 0.001 + index) * 0.1})`;
        });
        
        requestAnimationFrame(() => this.animate());
    }
    
    addRippleEffect(e) {
        const ripple = document.createElement('div');
        const rect = this.container.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        ripple.style.cssText = `
            position: absolute;
            left: ${x}px;
            top: ${y}px;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.6) 0%, transparent 70%);
            pointer-events: none;
            animation: ripple 0.8s ease-out;
            transform: translate(-50%, -50%);
        `;
        
        this.container.appendChild(ripple);
        
        setTimeout(() => ripple.remove(), 800);
    }
}

const rippleStyle = document.createElement('style');
rippleStyle.textContent = `
    @keyframes ripple {
        to {
            width: 200px;
            height: 200px;
            opacity: 0;
        }
    }
`;
document.head.appendChild(rippleStyle);

document.addEventListener('DOMContentLoaded', () => {
    const liquidGlass = new LiquidGlass();
    
    document.querySelector('.liquid-glass').addEventListener('click', (e) => {
        liquidGlass.addRippleEffect(e);
    });
});