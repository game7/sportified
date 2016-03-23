import Ember from 'ember';

export default function buildOperationUrl(record, opPath, requestType, instance=true) {
  const modelName = record.constructor.modelName || record.constructor.typeKey;
  let adapter = record.store.adapterFor(modelName);
  let path = opPath;
  let snapshot = record._createSnapshot();
  let baseUrl = adapter.buildURL(modelName, instance ? record.get('id') : null, snapshot, requestType);

  if (baseUrl.charAt(baseUrl.length - 1) === '/') {
    return `${baseUrl}${path}`;
  } else {
    return `${baseUrl}${path}`;
  }
}
