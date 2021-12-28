const { readFileSync } = require('fs');
const { range } = require('./_utils');
const input = readFileSync('23.input.txt').toString();


const LEFT = 0
const JIM = 2 // JIM
const ROBBY = 4 // ROBBY
const JOHN = 6 // John
const RAY = 8 // RAY
const RIGHT = 10
const A1 = 11
const A2 = 12
const B1 = 13
const B2 = 14
const C1 = 15
const C2 = 16
const D1 = 17
const D2 = 18

const THE_DOORS = [JIM, ROBBY, JOHN, RAY];

const isDoor = (i) => THE_DOORS.includes(i)

const COSTS = {
  A: 1,
  B: 10,
  C: 100,
  D: 1000
}

const DOORS = {
  A: JIM,
  B: ROBBY,
  C: JOHN,
  D: RAY
}

const ROOMS = {
  A: [A1, A2],
  B: [B1, B2],
  C: [C1, C2],
  D: [D1, D2]
}

const TARGET = '...........AABBCCDD';


const state2input = (state) => {
  const ret =  `#############
#${state.substring(0, 11)}#
###${state[A1]}#${state[B1]}#${state[C1]}#${state[D1]}###
  #${state[A2]}#${state[B2]}#${state[C2]}#${state[D2]}#
  #########`;
  return ret;

}
const input2state = (input) => {
  const lines = input.split('\n');
  let str = lines[1].substring(1, 12);
  str += lines[2][3] + lines[3][3];
  str += lines[2][5] + lines[3][5];
  str += lines[2][7] + lines[3][7];
  str += lines[2][9] + lines[3][9];
  return str;
}

const swap = (state, a, b) => {
  const c1 = state[a];
  const c2 = state[b];
  const ret = [...state];
  ret[a] = c2;
  ret[b] = c1;
  return ret.join("");
}

const getNextOut = (state) => {
  const next = []
  // room to hallway
  const confs = [
    [A1, A2, JIM],
    [B1, B2, ROBBY],
    [C1, C2, JOHN],
    [D1, D2, RAY],
  ]
  for (let [s1, s2, door] of confs) {
    let start_pos;
    let steps = 0
    if (state[s1] != '.') {
      start_pos = s1;
      steps = 1;
    } else if (state[s2] != '.') {
      start_pos = s2;
      steps = 2;
    }
    if (start_pos) {
      const char = state[start_pos];
      const factor = COSTS[char];
      for (let i of range(door - 1, LEFT)) {
        //Check to the left
        const c = state[i];
        if (c == '.') {
          if (isDoor(i))
            continue;
          //steps += Math.abs(door - i);
          next.push({ state: swap(state, start_pos, i), cost: (steps+Math.abs(door - i)) * factor })
        } else {
          break;
        }
      }
      for (let i of range(door + 1, RIGHT)) {
        //Check to the left
        const c = state[i];
        if (c == '.') {
          if (isDoor(i))
            continue;
          //steps += Math.abs(door - i);
          next.push({ state: swap(state, start_pos, i), cost: (steps+Math.abs(door - i)) * factor })
        } else {
          break;
        }
      }
    }
  }
  return next;
}

const getNextIn = (state) => {
  const next = [];
  const confs = [
    ['A', A1, A2, JIM],
    ['B', B1, B2, ROBBY],
    ['C', C1, C2, JOHN],
    ['D', D1, D2, RAY],
  ]
  for (let [cc, s1, s2, door] of confs) {
    middle_loop:
    for (let i of range(LEFT, RIGHT)) {
      const char = state[i];
      const factor = COSTS[char];
      let steps = 0;
      // search the hallway, 
      if (!isDoor(i) && char !== '.') {
        if (char === cc) {
          // check if their room is free
          let target_pos;
          if (state[s1] == '.') {
            if (state[s2] == '.') {
              target_pos = s2;
              steps = 2;
            } else if (state[s2] == cc) {
              target_pos = s1;
              steps = 1;
            }
          }
          // check if path is clear
          if (target_pos) {
            let first = true;
            for (let n of range(i, door)) {
              if (first) {
                first = false;
              } else {
                steps++
                if (state[n] != '.') {
                  continue middle_loop;
                }
              }
            }
            //move
            next.push({ state: swap(state, i, target_pos), cost: steps * factor })
          }
        }

      }
    }
  }
  return next;
}

const getNextDirect = (state) => {
  const next = [];
  const confs = [
    ["A", A1, A2, JIM],
    ["B", B1, B2, ROBBY],
    ["C", C1, C2, JOHN],
    ["D", D1, D2, RAY],
  ]
  outer_loop:
  for (let [cc,s1, s2, door] of confs) {
    let start_pos;
    let steps = 0
    if (state[s1] != '.') {
      start_pos = s1;
      steps += 1;
    } else if (state[s2] != '.') {
      start_pos = s2;
      steps += 2;
    }
    if(start_pos){
      const char = state[start_pos];
      const factor = COSTS[char];
      //already in correct room
      if(char === cc) 
        continue outer_loop;
      let target_pos;
      // check if room for char is free
      const [t1,t2] = ROOMS[char];
      if (state[t1] == '.') {
        if (state[t2] == '.') {
          target_pos = t2;
          steps += 2;
        } else if (state[t2] == char) {
          target_pos = t1;
          steps += 1;
        }
      }
      if(target_pos){
        // Check if hallway is free
        const target_door = DOORS[char];
        for(i of range(door,target_door)){
          if(state[i]!=='.')
            continue outer_loop;
          steps++;
        }
        steps--; // first step is counted by start_pos steps
        next.push({ state: swap(state, start_pos, target_pos), cost: steps * factor })
      }
    }
  }
  return next;
}

const getNext = (state) => [...getNextOut(state), ...getNextIn(state), ...getNextDirect(state)]

const state = input2state(input);
console.log(getNext(state)[0])
const allNext = getNextOut(state); 

/*
allNext.map(n=>n.state).forEach(state=>{
  console.log(state2input(state));
  console.log();
});
*/
/*
allNext.forEach(({state, cost})=>{
  console.log(state2input(state))
  console.log(cost)
})*/



//process.exit();

var clear = '\033[2J';
let i = 0;



const start = input2state(input);
const frontier = [];
const came_from = {};
const cost_so_far = {};

function dequeue(){
  let cost = Number.POSITIVE_INFINITY
  let node = null;
  let n = -1;
  frontier.forEach((value, index)=>{
    const current_cost = cost_so_far[value]??Number.POSITIVE_INFINITY
    if(current_cost < cost){
      node = value;
      n = index;
      cost = current_cost;
    }
  })
  return frontier.splice(n,1)[0];
}


frontier.push(start);
cost_so_far[start] = 0;

let found = false;
outer_loop:
while (frontier.length > 0) {
  console.log(clear);
  console.log(frontier.length );
  console.log(cost_so_far[TARGET]);
  //const current = frontier.pop();
  const current = dequeue();
  const current_cost = cost_so_far[current];
  const allNext = getNext(current);
  for(let {state, cost} of allNext){
    if(typeof(cost_so_far[state]) == 'undefined' ||
    cost_so_far[state] > current_cost + cost){
      came_from[state] = current;
      cost_so_far[state] = current_cost + cost;
      frontier.push(state);
      //console.log(frontier.length)
      /*
      if(state === TARGET){
        found = true;
        break outer_loop;
      }*/
    }
  }
}



console.log({found});
//console.log(came_from);

const path = [TARGET];
let current = TARGET;
do {
  current = came_from[current];
  path.push(current);
} while(current !== start)
if (found){
  do {
    current = came_from[current];
    path.push(current);
  } while(current !== start)
   /*
 const interval = setInterval(() => {
  console.log(clear);
  console.log(state2input(path[path.length-i-1]));
  console.log(cost_so_far[path[path.length-i-1]]);
  i = (i + 1) 
  if(i === path.length){
    clearInterval(interval);
  }
}, 600)*/

}

console.log((path||[]).map((state)=>{
  return (state2input(state) + "\n" + cost_so_far[state] + "\n")
}).join("\n\n"));
console.log(cost_so_far[TARGET]);
 



