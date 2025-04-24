export function detectEnvironment(): 'local' | 'cloud' {
    // Kubernetes establece algunas variables de entorno específicas
    if (process.env.KUBERNETES_SERVICE_HOST) {
      return 'cloud';
    } 
    
    // También podemos verificar Google Cloud o AWS
    if (process.env.GCP_PROJECT || process.env.AWS_REGION) {
      return 'cloud';
    }
    
    return 'local';
  }