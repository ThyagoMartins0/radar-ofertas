/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string;
  /** Fallback se a API ainda não expuser novncUrl (mesmo valor que MANAGER_NOVNC_PUBLIC_URL). */
  readonly VITE_NOVNC_PUBLIC_URL: string;
}

interface Window {
  __API_BASE_URL__?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
