import { describe, expect, it } from 'vitest';

import { resolveApiBaseUrl } from './api-base-url.js';

describe('resolveApiBaseUrl', () => {
  it('prioriza a URL de runtime', () => {
    expect(resolveApiBaseUrl('https://backlmbot.simplapp.com.br/', 'https://other')).toBe(
      'https://backlmbot.simplapp.com.br',
    );
  });

  it('usa o build quando runtime está vazio', () => {
    expect(resolveApiBaseUrl('  ', 'https://api.exemplo.com/')).toBe('https://api.exemplo.com');
  });

  it('retorna vazio para same-origin', () => {
    expect(resolveApiBaseUrl('', '')).toBe('');
  });
});
