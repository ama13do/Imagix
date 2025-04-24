import express, { Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import proxy from 'express-http-proxy';
import { config } from './config';

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Health check endpoint
app.get('/health', (req: Request, res: Response) => {
  res.status(200).json({ status: 'ok' });
});

// Proxy para servicio de traducción
app.use('/api/translator', proxy(config.services.translator.url, {
  proxyReqPathResolver: (req) => `/api${req.url}`
}));

// Proxy para procesador DICOM
app.use('/api/dicom', proxy(config.services.dicomProcessor.url, {
  proxyReqPathResolver: (req) => `/api${req.url}`
}));

// Proxy para convertidor de imágenes
app.use('/api/images', proxy(config.services.imageConverter.url, {
  proxyReqPathResolver: (req) => `/api${req.url}`
}));

// Proxy para servicio de distribución
app.use('/api/distribution', proxy(config.services.distribution.url, {
  proxyReqPathResolver: (req) => `/api${req.url}`
}));

// Proxy para notificaciones
app.use('/api/notifications', proxy(config.services.notification.url, {
  proxyReqPathResolver: (req) => `/api${req.url}`
}));

// Error handling
app.use((err: any, req: Request, res: Response, next: any) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Algo salió mal!' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API Gateway corriendo en puerto ${PORT}`);
});

export default app;