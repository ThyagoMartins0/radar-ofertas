import { afterEach, describe, expect, it, vi } from 'vitest';

import { buildNovncUrl, isNovncMisconfigured, resolveNovncUrl } from './novnc.js';

function stubHostname(hostname: string): void {
  vi.stubGlobal('location', { ...window.location, hostname });
}

describe('resolveNovncUrl', () => {
  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('prioriza novncUrl da API', () => {
    expect(
      resolveNovncUrl({
        novncUrl: 'https://vnc.example.com',
        novncPort: 6080,
      }),
    ).toBe('https://vnc.example.com/vnc_lite.html?scale=true&path=websockify');
  });

  it('não monta porta no hostname do painel fora de localhost', () => {
    stubHostname('rdofertas.simplapp.com.br');
    expect(resolveNovncUrl({ novncPort: 6080 })).toBeNull();
  });

  it('detecta misconfig quando só há porta', () => {
    stubHostname('rdofertas.simplapp.com.br');
    expect(isNovncMisconfigured({ novncPort: 6080 })).toBe(true);
    expect(
      isNovncMisconfigured({
        novncPort: 6080,
        novncUrl: 'https://vnc.example.com',
      }),
    ).toBe(false);
  });
});

describe('buildNovncUrl', () => {
  it('retorna null sem porta', () => {
    expect(buildNovncUrl(null)).toBeNull();
    expect(buildNovncUrl(undefined)).toBeNull();
    expect(buildNovncUrl(0)).toBeNull();
  });

  it('monta URL com hostname local', () => {
    expect(buildNovncUrl(6080)).toBe(
      `http://${window.location.hostname}:6080/vnc_lite.html?scale=true&path=websockify`,
    );
  });
});
