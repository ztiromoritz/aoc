const { assert } = require('console');
const { readFileSync } = require('fs');
const { eqSet } = require('./_utils');
const input = readFileSync('08.input.txt');
const data = input.toString()
    .split('\n')
    .filter(Boolean).map(_ => _.split('|'))
    .map(([left, right]) => [left.split(' '), right.split(' ').filter(Boolean).filter(Boolean)]);


const result1 = data.reduce((acc, [left, right]) => {
    const count = right.filter(_ => [2, 3, 4, 7].includes(_.length)).length
    return acc + count;
}, 0)

console.log("Result 1", result1);


const SEGMENTS = [
    6, // 0
    2, // 1
    5,
    5,
    4, // 4
    5,
    6,
    3, // 7
    7, // 8
    6
]




function getMapping({ one, four, seven, eight }) {
    const ONE = new Set([...one]);
    const FOUR = new Set([...four]);
    const SEVEN = new Set([...seven]);
    const EIGHT = new Set([...eight]);
    const a = seven.filter(_ => !ONE.has(_))[0];
}

const translate = ({ one, four, seven, eight, nine }) => {
    const ONE = new Set([...one]);
    const FOUR = new Set([...four]);
    const SEVEN = new Set([...seven]);
    const EIGHT = new Set([...eight]);
    const NINE = new Set([...nine]);

    return (value) => {
        const length = value.length
        if (length === 2) {
            return 1
        }
        if (length === 4) {
            return 4;
        }
        if (length === 3) {
            return 7;
        }
        if (length === 7) {
            return 8;
        }
        const VALUE = new Set([...value]);


        if (length === 5) { //2, 3, 5
            // 7 fits only complete in 3 => 3
            // 4 has b and f not in 2 
            // 4 has only c not in 5
            if ([...seven].filter(_ => VALUE.has(_)).length === 3) {
                return 3
            }
            const cnt = [...four].filter(_ => !VALUE.has(_)).length;
            if (cnt === 2)
                return 2;
            if (cnt === 1)
                return 5;
            console.log({ one, four, seven, eight, value, cnt })
            throw new Error('Should not happen');
        }
        if (length === 6) { //0, 6, 9
            console.log("eq", VALUE, NINE);
            if (eqSet(VALUE, NINE)) {

                return 9
            }
            if ([...seven].some(_ => !VALUE.has(_))) {
                return 6;
            }
            return 0;
        }
    }

}

const get235 = ({ one, four, seven, eight, left }) => {
    const ONE = new Set([...one]);
    const FOUR = new Set([...four]);
    const SEVEN = new Set([...seven]);
    const EIGHT = new Set([...eight]);

    const candidates = left.filter(_ => _.length === 5);
    assert(candidates.length === 3);
    const result = {};
    candidates.forEach((value) => {
        const VALUE = new Set([...value]);
        if ([...seven].filter(_ => VALUE.has(_)).length === 3) {
            result.three = value;
        } else {
            const cnt = [...four].filter(_ => !VALUE.has(_)).length;
            if (cnt === 2) {
                result.two = value
            } else if (cnt === 1) {
                result.five = value;
            } else {
                console.log({ one, four, seven, eight, value, cnt })
                throw new Error('Should not happen');
            }
        }
    })
    return result;
}


const UNIQUE = [2, 3, 4, 7]


const sg = `
  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
gggg    ....    gggg    gggg    ....

   5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg
`


const result2 = data.map(([left, right]) => {
    const one = left.find(_ => _.length === 2);
    const four = left.find(_ => _.length === 4);
    const seven = left.find(_ => _.length === 3);
    const eight = left.find(_ => _.length === 7);
    const { two, three, five } = get235({ one, four, seven, eight, left });
    const nine = [...new Set([...five, ...seven]).keys()].join("");
    console.log(nine);

    t = translate({ one, four, seven, eight, nine });
    const value = right.map(t).join('');
    console.log(value);
    return value;
}).map(_ => parseInt(_, 10)).reduce((a, b) => a + b, 0);

console.log(result2);


