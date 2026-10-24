export type { ApiErrorBody } from './api-types.js';
export type * from './api-types.js';

export class ApiError extends Error {
  readonly status: number;
  readonly code: string;
  readonly details?: unknown;

  constructor(status: number, body: import('./api-types.js').ApiErrorBody) {
    super(body.error);
    this.name = 'ApiError';
    this.status = status;
    this.code = body.code;
    this.details = body.details;
  }
}
