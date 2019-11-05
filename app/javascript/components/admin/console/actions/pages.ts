import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Section {
  createdAt: string
  id: number
  pageId: number
  pattern: string
  position: number
  updatedAt: string
  blocks: Block[]
}

export interface GenericBlock<T> {
  column: number
  createdAt: string
  id: number
  options: T
  pageId: number
  position: number
  sectionId: number
  type: string
  updatedAt: string
}

export interface Block extends GenericBlock<any> {}

interface MarkupBlockOptions {
  body: string
}

export interface MarkupBlock extends GenericBlock<MarkupBlockOptions> {}

interface ImageBlockOptions {
  alignment: string;
  linkUrl: string;
}

export interface ImageBlock extends GenericBlock<ImageBlockOptions> {}

interface DocumentBlockOptions {
  title: string;
  description: string;
}

export interface DocumentBlock extends GenericBlock<DocumentBlockOptions> {}

interface ContactBlockOptions {
  email: string
  first: string
  last: string
  phone: string
  title: string
}

export interface ContactBlock extends GenericBlock<ContactBlockOptions> {}

interface TextBlockOptions {
  body: string
  caption: string
  title: string,
  render: string
}

export interface TextBlock extends GenericBlock<TextBlockOptions> {}

interface FeedBlockOptions {
  tags: string
  title: string
}

export interface FeedBlock extends GenericBlock<FeedBlockOptions> {}

interface CarouselBlockOptions {
  postCount: string
  shuffle: boolean
  tags: string
}

export interface CarouselBlock extends GenericBlock<CarouselBlockOptions> {}

export interface DividerBlock extends GenericBlock<{}> {}

interface EventFeedBlockOptions {
  title: string
  tags: string
  eventCount: number
}

export interface EventFeedBlock extends GenericBlock<EventFeedBlockOptions> {}


export interface Page {
  ancestry: string
  ancestryDepth: number
  content: string
  createdAt: string
  draft: boolean
  id: number
  linkUrl: string
  metaDescription: string
  metaKeywords: string
  position: number
  showInMenu: boolean
  skipToFirstChild: boolean
  slug: string
  tenantId: number
  title: string
  titleInMenu: ""
  updatedAt: string
  urlPath: string
  sections?: Section[]
}

export const list: ActionHandler<{}, Page[]> = (payload) => {
  return dispatch<{}, Page[]>({
    type: 'pages/list',
    payload
  }).then(res => res['pages'])
}

export const find: ActionHandler<{ id: number }, Page> = (payload) => {
  return dispatch<{ id: number }, Page>({
    type: 'pages/find',
    payload
  }).then(res => res['page'])
}

