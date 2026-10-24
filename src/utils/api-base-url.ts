export function resolveApiBaseUrl(
  runtimeUrl = typeof window === 'undefined' ? '' : window.__API_BASE_URL__,
  buildUrl = import.meta.env.VITE_API_BASE_URL,
): string {
  const runtime = runtimeUrl?.trim();
  if (runtime) return runtime.replace(/\/$/, '');

  const configured = buildUrl?.trim();
  if (configured) return configured.replace(/\/$/, '');

  return '';
}
