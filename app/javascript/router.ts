import { FormDataConvertible, Inertia, VisitOptions } from "@inertiajs/inertia";
import { Params, path } from "~/static-path";

export type FormData = Record<string, FormDataConvertible>;

// eslint-disable-next-line
export type WrappedModelPayload = { [modelName: string]: any };

export function asPayload<TPayload>(payload: TPayload): Record<string, FormDataConvertible> {
  return payload as Record<string, FormDataConvertible>;
}

function handleGet<TPattern extends string>(pattern: TPattern) {
  return function handler(params: Params<TPattern>, options?: VisitOptions) {
    return Inertia.get(path(pattern)(params), undefined, options);
  };
}

function handlePut<TPattern extends string>(pattern: TPattern) {
  return function handler(params: Params<TPattern>, data?: WrappedModelPayload | undefined, options?: VisitOptions) {
    return Inertia.put(path(pattern)(params), asPayload(data), options);
  };
}

function handlePatch<TPattern extends string>(pattern: TPattern) {
  return function handler(params: Params<TPattern>, data?: WrappedModelPayload | undefined, options?: VisitOptions) {
    return Inertia.patch(path(pattern)(params), asPayload(data), options);
  };
}

function handlePost<TPattern extends string>(pattern: TPattern) {
  return function handler(params: Params<TPattern>, data?: WrappedModelPayload | undefined, options?: VisitOptions) {
    return Inertia.post(path(pattern)(params), asPayload(data), options);
  };
}

function handleDelete<TPattern extends string>(pattern: TPattern) {
  return function handler(params: Params<TPattern>, options?: VisitOptions) {
    return Inertia.delete(path(pattern)(params), options);
  };
}

function handlePath<TPattern extends string>(pattern: TPattern) {
  return function handler(params: Params<TPattern>) {
    return path(pattern)(params);
  };
}

export const handle = {
  get: handleGet,
  put: handlePut,
  patch: handlePatch,
  post: handlePost,
  delete: handleDelete,
  path: handlePath,
};
