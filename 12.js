const { readFileSync } = require('fs');
const input = readFileSync('12.input.txt');

const next = {};
const lines = input.toString().split('\n').filter(Boolean).map(_=>_.split('-'));
for (let line of lines){
    next[line[0]] = next[line[0]]??[];
    next[line[0]].push(line[1]);

    next[line[1]] = next[line[1]]??[];
    next[line[1]].push(line[0]);
}


console.log(next);

const results = [];
function search(path, visited, joker){
    const current = path[path.length-1];
    if(current === 'end'){
        results.push([...path]);
    }else {
        const smallCave = current === current.toLowerCase()
        if(smallCave) visited.push(current);
        for(let child of next[current] || []){
            if(child === child.toUpperCase() || !visited.includes(child)){
                path.push(child);
                search(path, visited, joker)
                path.pop();
            } else {
                if(visited.includes(child)){
                    if(!joker && child !=='start'){
                        path.push(child);
                        search(path, visited, true)
                        path.pop();
                    }
                }
            }
        }
        if(smallCave) visited.pop();
       
    }
}

search(['start'],['start'],false);
console.log(results.length);



