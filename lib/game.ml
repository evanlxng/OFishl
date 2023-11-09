(** Type representing fish species *)
type fish_species = Goldfish | Pufferfish | Shark

(** Type representing fish foods *)
type fish_food = Fish | Pellet

type fish = {
  species : fish_species;
  mutable num : int;
  mutable age_sum : int;
  mutable health : int;
  food : fish_food;
}
(** Type representing a population of fish. 
    Contains fields for the species name, how many, the collective age and health *)

(**Returns a string representation of fish_species*)
let species_to_string (f : fish) : string =
  match f.species with
  | Goldfish -> "Goldfish"
  | Pufferfish -> "Pufferfish"
  | Shark -> "Shark"

(* Total number of fish species *)
let num_species = 3

type tank = fish array
(** Type representing a tank of fish *)

type player_state = {
  mutable round : int;
  mutable money : int;
  mutable tank : tank;
  max_rounds : int;
}
(** Type representing current game state *)

(** Creates a custom new fish population *)
let make_fish (species : fish_species) (food : fish_food) : fish =
  { species; num = 0; age_sum = 0; health = 0; food }

(** Sets a tank to an empty tank with new fish populations *)
let set_tank (t : tank) : unit =
  t.(0) <- make_fish Goldfish Pellet;
  t.(1) <- make_fish Pufferfish Pellet;
  t.(2) <- make_fish Shark Fish

(* Returns position of fish species in tank array *)
let fish_pos (s : fish_species) : int =
  match s with Goldfish -> 0 | Pufferfish -> 1 | Shark -> 2

(** Given a fish population, updates the age sum *)
let age_fish (f : fish) : unit = f.age_sum <- f.age_sum + f.num

(** Given a tank, updates the age of every fish in the tank by one round *)
let age_tank (t : tank) : unit =
  for x = 0 to Array.length t do
    age_fish t.(x)
  done

(** Given a fish and an integer i, adds i to the fish's health *)
let health_fish (f : fish) (i : int) : unit = f.health <- f.health + i

(** Updates health of a given species of fish in a tank *)
let health_tank (t : tank) (s : fish_species) (i : int) : unit =
  let pos = fish_pos s in
  health_fish t.(pos) i

(** Returns a new game instance with i rounds. A player starts with $100 and 
    one nursery tank. *)
let start_game (i : int) : player_state =
  {
    round = 1;
    money = 100;
    tank = Array.make num_species goldfish;
    max_rounds = i;
  }

(** Sets tank in a new game to the empty tank *)
let set_game (g : player_state) : unit = set_tank g.tank

(** Adds n to fish population f *)
let add_fish (f : fish) (n : int) : unit = f.num <- f.num + n

(** Adds n to fish population of species s in tank t *)
let add_fish_tank (t : tank) (s : fish_species) (n : int) : unit =
  let pos = fish_pos s in
  add_fish t.(pos) n

(** Adds n to fish population of species s in player state's tank *)
let add_fish_game (g : player_state) (s : fish_species) (n : int) : unit =
  add_fish_tank g.tank s n

(** Updates player state's round number and tank ages after one round. *)
let end_of_round (g : player_state) : unit =
  g.round <- g.round + 1;
  age_tank g.tank

(* CHANGE IMPLEMENTATION OF FUNCTIONS BELOW *)

(** Prints a fish's name, speies, and age. Helper function for print_fish_list. *)
let print_fish (f : fish) : string =
  species_to_string f ^ "       " ^ string_of_int f.num ^ "       "
  ^ string_of_int f.age_sum ^ "       " ^ string_of_int f.health

let print_tank (t : tank) : string =
  "\n\
  \ Tank Contents: \n\
  \ Species:      # of Fish:      Age Score:      Health Level: \n"
  ^ print_fish t.(0)
  ^ "\n"
  ^ print_fish t.(1)
  ^ "\n"
  ^ print_fish t.(2)

let print_playermoney (g : player_state) : int = g.money

(** Initialize a round by printing the current round and currency. *)
let start_round_print (g : player_state) : string =
  "Day " ^ string_of_int g.round ^ "\nYou currently have $"
  ^ string_of_int g.money ^ "."

(** End of round string with a players fish in a table. *)
let end_round_print (g : player_state) : string = print_tank g.tank

let cost (g : player_state) (cost : int) : unit = g.money <- g.money - cost
