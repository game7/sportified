
import { useState } from 'react';
import { startCase } from 'lodash';

interface BindOptions {
errorKey: string;
}

type SubmitHandler<T> = (model: Partial<T>, setErrors: (errors: any) => void) => void

  
export function useForm<T>(data: Partial<T>, handler?: SubmitHandler<T>) {
    const [model, setModel] = useState<Partial<T>>(data);
    const [errors, setErrors] = useState()

    function humanize(str: string) { return startCase(str) }
    
    function changeHandler(prop: keyof T, errorKey: string) {
      return function handleChange(event, control) {
        if(control.type == 'checkbox') {
          setModel(model => ({ ...model, [prop]: control.checked }))
        } else {
          setModel(model => ({ ...model, [prop]: control.value || '' }))
        }
        setErrors(errors => {
          let copy = { ...errors };
          delete copy[errorKey];
          return copy;
        })
      }
    }

    function submit() {
      if(handler) { handler(model, setErrors) }
    }    

    function form() {
      return {
        onSubmit: submit
      }
    }
    
    function input(prop: keyof T, options?: Partial<BindOptions>) {
      const { errorKey = prop.toString() } = options || {}
      return {
        label: humanize(prop.toString()),
        value: model[prop] || "",
        onChange: changeHandler(prop, errorKey),
        error: errors && errors[errorKey] && errors[errorKey][0]
      }
    }

    function checkbox(prop: keyof T, options?: Partial<BindOptions>) {
      const { errorKey = prop.toString() } = options || {}
      return {
        label: humanize(prop.toString()),
        checked: !!model[prop],
        onChange: changeHandler(prop, errorKey),
        error: errors && errors[errorKey] && errors[errorKey][0]
      }
    }

    return {
      input,
      checkbox,
      form,
      submit,
      model,
      setModel,
      setErrors
    }
  }