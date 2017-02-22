module CssTypes exposing ( Classes(..)
                         , Ids(..)
                         , indexNamespace)

import Html.CssHelpers exposing (withNamespace)

type Classes
  = Box
  | Header
  | Container
  | Footer

type Ids
  = Page

indexNamespace : Html.CssHelpers.Namespace String class id msg
indexNamespace =
  withNamespace "index"

