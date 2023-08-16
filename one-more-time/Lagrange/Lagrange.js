function zeros(n) {
   var arr = new Array(n);
   for (var i=n; i--;) {
     arr[i] = 0;
   }
   return arr;
}

function denom(i, points) {
   var p = 1;
   var x = points[i].x;
   for (var j = points.length; j--;) {
      if (i != j) {
        p *= x - points[j].x;
      }
   }
   return p;
}

// interpolating in form of Li polynomial
function interpolate(i, points) {
   var coeff = zeros(points.length);
   coeff[0] = 1/denom(i,points);
   var new_coeff;

   for (var k = 0; k < points.length; k++) {
        if (k == i) {
          continue;
        }
        new_coeff = zeros(points.length);
        for (var j= (k < i) ? k+1 : k; j--;) {
            if (j < 2) {
                new_coeff[j+1] += coeff[j];
                new_coeff[j] -= points[k].x*coeff[j];
                //console.log(k);
                //console.log(j);
                //console.log(new_coeff);
            }
        }
        coeff = new_coeff;
   }
   return coeff;
}

// coefficients of polynomial
function Lagrange(points) {
   var polynom = zeros(points.length);
   var coeff;
   for (var i=0; i<points.length; i++) {
     coeff = interpolate(i, points);
     for (var k=0; k<points.length; k++) {
        polynom[points.length - 1 - k] += points[i].y*coeff[k];
     }
   }
   return polynom;
}

function makeStruct(keys) {
  if (!keys) return null;
  const k = keys.split(', ');
  const count = k.length;

  /** @constructor */
  function constructor() {
    for (let i = 0; i < count; i++) this[k[i]] = arguments[i];
  }
  return constructor;
}

const point = new makeStruct("x, y");
var points = [];

var fs = require('fs')
fs.readFile('ingput.txt', 'utf-8', (err, data) => {
   if (err) throw err;
      let info = data.toString().match(/\d+/g);
   
      for (var e = 0; e <= info[0]; e++) {
         points.push(new point(info[2*e + 1], info[2*e + 2]));
      }
      const final = Lagrange(points).toString();
      console.log(final);
      var save = require('fs');
      save.writeFile('otput.txt', final, (err) => {
         if (err) throw err;
         else{
            console.log("Lagrange coefficients successfully written.");
         }
   });
});