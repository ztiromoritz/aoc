for(let char = 0 ; char <12; char++){
    for(let i of co.all){
        const value = data[i]
        if(value[char]==="0"){
            co.zeros.push(i);
            elements[i].style.color="blue";
        }else{
            co.ones.push(i);
            elements[i].style.color="green";
        }     
        //if(i%4===0)await wait(0);      
    }
    if(co.ones.length < co.zeros.length){
        co.all = [...co.ones];
        co.ones.map(i=>elements[i].style.color="black");
        co.zeros.map(i=>elements[i].style.color="#00000011");
    }else{ 
        co.all = [...co.zeros];
        co.ones.map(i=>elements[i].style.color="#00000011");
        co.zeros.map(i=>elements[i].style.color="black");
    }
    
    co.ones = [];
    co.zeros = [];
    if(co.all.length===1){
        console.log(data[co.all[0]]);
        break;
    }
}