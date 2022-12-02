import { capitalize, trimStart } from "lodash";

// ts equivalent of ActiveSupprt::Inflector.humanize
//https://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-humanize
// Specifically, performs these transformations:
// - [ ] Applies human inflection rules to the argument.
// - [x] Deletes leading underscores, if any.
// - [x] Removes an “_id” suffix if present.
// - [x] Replaces underscores with spaces, if any.
// - [o] Downcases all words except acronyms.
// - [x] Capitalizes the first word.
//
// note: in the future this may be better suited to js/ts if modified
// to humanize camelcase words rather than underscore
export function humanize(
  lowerCaseAndUnderscoredWord: string,
  options?: { capitalize: boolean }
): string {
  options = { ...{ capitalize: true }, ...options };

  let result = lowerCaseAndUnderscoredWord;
  result = trimStart(result, "_");
  result = result.replace(/_id$/, "");
  result = result.replace(/_/g, " ");
  result = result.toLowerCase();

  if (options.capitalize) {
    result = capitalize(result);
  }

  return result;
}
