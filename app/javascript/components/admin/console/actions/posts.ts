import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Post {
  body: string
  createdAt: string
  id: number
  image: string
  linkUrl: string
  summary: string
  tagList: string
  tenantId: number
  thumbUrl: string
  title: string
  updatedAt: string
}

export const list: ActionHandler<{}, Post[]> = (payload) => {
  return dispatch<{}, Post[]>({
    type: 'posts/list',
    payload
  }).then(res => res['posts'])
}

interface PreviewPayload {
  markdown: string;
}

interface PreviewResponse {
  preview: string
}

export const preview: ActionHandler<PreviewPayload, PreviewResponse> = (payload) => {
  return dispatch<PreviewPayload, PreviewResponse>({
    type: 'posts/preview',
    payload
  })
}

export interface CreatePostPayload {
  title: string
  summary: string
  body: string
}

export const create: ActionHandler<Partial<CreatePostPayload>, Post> = (payload) => {
  return dispatch<Partial<CreatePostPayload>, Post>({
    type: 'posts/create',
    payload
  })
}

