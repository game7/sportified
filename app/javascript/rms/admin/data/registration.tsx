import { Form } from './form';

export interface Registration {
  id: number;
  variantId: number;
  firstName: string;
  lastName: string;
  birthdate: Date;
  email: string;
  price: number;
  status: string;
  forms: Form[];
  createdAt: Date;
  updatedAt: Date;
}
