// Snippet
const data = document.querySelector('pre').innerText.split(',').map(_=>parseInt(_));

const max = data.reduce((a,b)=>Math.max(a,b), Number.NEGATIVE_INFINITY);
const min = data.reduce((a,b)=>Math.min(a,b), Number.POSITIVE_INFINITY);
const sum = data.reduce((a,b)=>a+b, 0);
const avg = Math.round(sum/data.length);

const cost = (pos) => data.map(val=>Math.abs(val-pos)).reduce((a,b)=>a+b, 0);

const result = []; 
for(let pos = 0; pos<=max; pos++ ){
    result.push(cost(pos));
}

const result2 = [];
const cost2 = (pos) => data.map(val=>{
    const distance = Math.abs(val-pos);
    return (distance*(distance+1))/2
}).reduce((a,b)=>a+b, 0);
for(let pos = 0; pos<=max; pos++ ){
    result2.push(cost2(pos));
}



const canvas = document.createElement('canvas');
canvas.id="myChart";
document.body.append(canvas);
const script = document.createElement('script');
script.src = 'https://cdn.jsdelivr.net/npm/chart.js';
document.body.append(script);
script.onload =()=>{

const labels = result.map((_,index)=>index);
const data = {
  labels: labels,
  datasets: [{
    label: 'Part 1',
    backgroundColor: 'rgb(255, 99, 132)',
    borderColor: 'rgb(255, 99, 132)',
    data: result,
  },{
    label: 'Part 2',
    backgroundColor: 'rgb(0, 0, 255)',
    borderColor: 'rgb(0, 0, 255)',
    data: result2,
  }]
};

const config = {
  type: 'line',
  data: data,
  options: {
      scales: {
      x: {
        display: true,
      },
      y: {
        display: true,
        type: 'logarithmic',
      }
    }
  }
};

const myChart = new Chart(
    document.getElementById('myChart'),
    config
  );
};

const minResult = result.reduce((a,b)=>Math.min(a,b), Number.POSITIVE_INFINITY);
console.log({minResult});
const minResult2 = result2.reduce((a,b)=>Math.min(a,b), Number.POSITIVE_INFINITY);
console.log({minResult2});
