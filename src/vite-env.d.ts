/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string;
}

interface Window {
  __API_BASE_URL__?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
