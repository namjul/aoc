let day1 = (input) => {
  let list = Js.String.split("\n", input)
    |> Js.Array.map(float_of_string);
  let solution = ref(None);

  while (solution^ == None) {
    solution := Some(5);
  };
};

let input = "+1
+2
+3
+4
-5";

Js.log(day1(input));

