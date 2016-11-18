(** This type represents a coordinate in a hexagonal grid. We're using offset
  * coordinates -- a slight modification of cartesian coordinates to suit a
  * hexagonal grid. They look like this:
  *   ____        ____
  *  /(0,0)      /    \
  * /col   \____/(2,0) \
  * \ | row/====\==>   /
  *  \|___/ (1,0)\____/
  *  /|   \      /    \
  * / v    \____/ (2,1)\
  * \ (0,1)/    \      /
  *  \____/ (1,1)\____/
  *  /    \      /    \
  * / (0,2)\____/ (2,2)\
  * \      /    \      /
  *  \____/      \____/
  *)
type t
