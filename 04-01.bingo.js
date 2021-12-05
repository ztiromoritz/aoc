const {readFileSync} = require('fs');
const input = readFileSync('04.input.txt');
const lines = input.toString().split('\n');

const rnd = lines[0].split(',').map(_=>parseInt(_));

console.log(rnd);

const boards = [];

let boardProto = { 
    mark(value){
        for(let row of this.rows){
            for(let i in row){
                //console.log(value, row[i]);
                if(value===row[i]){
                    // mark by make it negative
                    row[i]*=-1; 
                }
            }
        }
    },
    isWon(){
        for(let row of this.rows){
            if(!row.some(_=>_>0)){
                return -row.reduce((a,b)=>a+b,0);
            }
        }
        for(let col = 0; col < 5; col++){
            let won=true;
            let sum=0;
            for(let row = 0; row < 5; row++){
                const v = this.rows[row][col];
                sum+=v;
                if(v>0){
                    won = false;
                }   
            }
            if(won){
                return -sum;
            }
        }
        return 0;
    },
    points(){
        let sum = 0;
        for(let row of this.rows){
            sum+=row.reduce((a,b)=>a+(b>0?b:0),0);
        }
        return sum;
    }
};
let board = Object.create(boardProto);
board.rows = [];
for(let n=2; n< lines.length; n++){
    const line = lines[n];
    if(line===""){
        boards.push(board);
        board = Object.create(boardProto);
        board.rows = [];
    }else{
        board.rows.push(line.match(/.{1,3}/g).map(_=>_.trim()).map(_=>parseInt(_)));
    }
}

//console.log(JSON.stringify(boards,null,1));

loop:
for(let value of rnd){
    let i = boards.length;
    //console.log(i);
    if(i===1){
        boards[0].mark(value);
        console.log(boards[0].points()*value);
        break loop;
    }
    while(i--){
        const board = boards[i];
        board.mark(value);
        if(board.isWon()){
            boards.splice(i,1)
        }
    }
    
}
//console.log(JSON.stringify(boards,null,1));

