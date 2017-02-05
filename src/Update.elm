module Update exposing (update)

import Array                   exposing (..)
import EventHandlers.OnClicked
import Model                   exposing (..)
import MyEvent                 exposing (..)
import Player                  exposing (..)

changePlayer : Player -> Player
changePlayer p = case p of
                   A -> B
                   B -> A
                   _ -> A

staleMate : Array Player -> Bool
staleMate ary = (0 == length(filter (\x -> x == Unclaimed) ary))

type alias GameStatus = Result String Player

playerWon : Player -> Model -> GameStatus
playerWon player model =
  let
      check : List Int -> Array Player -> Bool
      check indices ary = fromList indices
                            |> map (\index -> (get index ary |> Maybe.withDefault Unclaimed))
                            |> filter ((==) player)
                            |> length
                            |> (==) 3
      row1  = check [0, 1, 2] model.boxes
      row2  = check [3, 4, 5] model.boxes
      row3  = check [6, 7, 8] model.boxes

      col1  = check [0, 3, 6] model.boxes
      col2  = check [1, 4, 7] model.boxes
      col3  = check [2, 5, 8] model.boxes

      diag1 = check [0, 4, 8] model.boxes
      diag2 = check [6, 4, 2] model.boxes
  in
     if row1 || row2 || row3 || col1 || col2 || col3 || diag1 || diag2 then
       Ok model.currentPlayer
     else
       Err "Not there yet!"

update : MyEvent -> Model -> (Model, Cmd MyEvent)
update msg model =
  case msg of
    Reset -> initialModel ! []

    CheckWinner player currentPlayerShouldChange time ->
      if staleMate model.boxes then
        { model | winner = Just Unclaimed } ! []
      else
        case currentPlayerShouldChange of
          True -> case playerWon player model of
                    Ok player -> { model | winner        = Just player         } ! []
                    Err _     -> { model | currentPlayer = changePlayer player } ! []

          False -> model ! []

    Clicked index -> EventHandlers.OnClicked.onClicked model index
