import { detectEnvironment } from './utils/environment';

const env = detectEnvironment();

const serviceConfig = {
  local: {
    translator: { url: 'http://translator-service:4001' },
    dicomProcessor: { url: 'http://dicom-processor-service:4002' },
    imageConverter: { url: 'http://image-converter-service:4003' },
    distribution: { url: 'http://distribution-service:4004' },
    notification: { url: 'http://notification-service:4005' }
  },
  cloud: {
    translator: { url: 'http://translator-service.default.svc.cluster.local:4001' },
    dicomProcessor: { url: 'http://dicom-processor-service.default.svc.cluster.local:4002' },
    imageConverter: { url: 'http://image-converter-service.default.svc.cluster.local:4003' },
    distribution: { url: 'http://distribution-service.default.svc.cluster.local:4004' },
    notification: { url: 'http://notification-service.default.svc.cluster.local:4005' }
  }
};

export const config = {
  services: env === 'local' ? serviceConfig.local : serviceConfig.cloud,
  mongodb: {
    uri: process.env.MONGODB_URI || 'mongodb://mongodb:27017/medical-app'
  },
  storage: {
    local: {
      path: process.env.LOCAL_STORAGE_PATH || '/data/storage'
    },
    s3: {
      bucket: process.env.S3_BUCKET || 'medical-images',
      region: process.env.S3_REGION || 'us-east-1'
    },
    gcs: {
      bucket: process.env.GCS_BUCKET || 'medical-images'
    }
  }
};