const NOVNC_VIEWER_PATH = '/vnc_lite.html?scale=true&path=websockify';

export type NovncLinkSource = {
  novncUrl?: string | null;
  novncPort?: number | null;
};

function normalizeNovncViewerUrl(base: string): string {
  const trimmed = base.trim().replace(/\/$/, '');
  if (trimmed.includes('vnc_lite.html')) return trimmed;
  return `${trimmed}${NOVNC_VIEWER_PATH}`;
}

function isLocalHostname(hostname: string): boolean {
  return hostname === 'localhost' || hostname === '127.0.0.1';
}

/** Resolve a URL do noVNC: API/env primeiro; localhost+porta só em dev. */
export function resolveNovncUrl(source: NovncLinkSource = {}): string | null {
  const fromApi = source.novncUrl?.trim();
  if (fromApi) return normalizeNovncViewerUrl(fromApi);

  const fromEnv = import.meta.env.VITE_NOVNC_PUBLIC_URL?.trim();
  if (fromEnv) return normalizeNovncViewerUrl(fromEnv);

  return buildNovncUrl(source.novncPort);
}

/** @deprecated Prefer `resolveNovncUrl` — evita abrir `:6080` no hostname do painel em produção. */
export function buildNovncUrl(port: number | null | undefined): string | null {
  if (port == null || port <= 0) return null;
  if (typeof window === 'undefined') return null;

  const host = window.location.hostname;
  if (!isLocalHostname(host)) return null;

  return `http://${host}:${port}${NOVNC_VIEWER_PATH}`;
}

/** Abre o desktop do container (login ML). Deve ser chamado no clique do usuário. */
export function openNovncTab(source: NovncLinkSource): void {
  const url = resolveNovncUrl(source);
  if (!url) return;
  window.open(url, '_blank', 'noopener');
}

/** noVNC habilitado na API mas sem URL pública configurada (Dokploy). */
export function isNovncMisconfigured(source: NovncLinkSource): boolean {
  return (source.novncPort ?? 0) > 0 && resolveNovncUrl(source) == null;
}
