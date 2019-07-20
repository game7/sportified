import { Registration } from './registration';

export interface Item {
  id: string;
  title: string;
  description: string;
  active: boolean;
  registrations: Registration[];
}
