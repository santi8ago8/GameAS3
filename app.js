// watchify app.js  -o build.js -t babelify -t brfs -v -d

let Velocity = require('velocity-animate');
let _ = require('lodash');
let React = require('react');
let fs = require('fs');
let TranGroup = require('react-addons-transition-group');
let VelocityUI = require('velocity-animate/velocity.ui.js');
console.log(VelocityUI);
import Random from 'random-js';
import createBrowserHistory from 'history/lib/createBrowserHistory'
import Reactdom from 'react-dom';


let App = React.createClass({
    getInitialState(){
        return {
            isMenu: true,
            images: [
                {
                    time: 90 * 1000,
                    frase: 'El Tour de San Luis, es la competencia de categoría internacional mas importante de latinoamericano que se disputa anualmente en el mes de enero en San Luis.',
                    img: fs.readFileSync('./img/ciclista.svg').toString()
                },
                {
                    time: 140 * 1000,
                    frase: 'Juan Gilberto Funes fue un futbolista nacido en San Luis apodado el búfalo. Jugó y fue campeón mundial con el club atlético River Plate. En el dos mil tres se inauguró el estadio Juan Gilberto Funes en la ciudad de La Punta.',
                    img: fs.readFileSync('./img/futbol.svg').toString()
                },
                {
                    time: 150 * 1000,
                    frase: 'El cakuy es el nombre dado a un búho que por la noche en los montes y quebrachales de nuestro país, en quichua le dicen turay que quiere decir hermano. El sol lo enceguece, él está ciego durante el día, con los ojos fijos, pero llega la noche y grita, Cakuy... Cakuy...',
                    img: fs.readFileSync('./img/buho.svg').toString()
                },
                {
                    time: 200 * 1000,
                    frase: 'El León es poder, sabiduría, justicia, orgullo, seguridad en sí mismo, padre, juez y soberano, éxito y triunfo. Hay que tener el corazón de un León para ser capaces de silenciar, luchar y vencer al ego y a la materia. Considera en poco al León, que derrota al enemigo. El verdadero León es aquel, que se derrota a sí mismo.',
                    img: fs.readFileSync('./img/leon.svg').toString()
                }
            ]
        };

    },

    render(){
        let properties = {};
        let NodeRender;

        if (this.state.isMenu) {
            NodeRender = <Menu key="menu" lev={this.state.levSel} jugar={this.jugar}/>;
        } else {
            NodeRender = <Game showMenu={this.showMenu} svg={this.state.svg} key="game"/>;
        }

        //
        //debugger;


        return (<TranGroup component="div" key="main">
            {NodeRender}
        </TranGroup>)

    },

    showMenu(){
        this.setState({
            isMenu: true,
            levSel: true
        });
    },

    jugar(ev, ind){

        let index;
        if (typeof ind !== 'undefined')
            index = ind;
        if (ev)
            index = ev.target.getAttribute('data-index');
        //this.state.svg =
        this.setState({
            svg: this.state.images[index],
            isMenu: false
        });
        /*setTimeout(()=> {
         this.setState({
         svg: this.state.images[1],
         isMenu: false
         });
         }, 10000)*/
    }
});

let Logo = React.createClass({
    render(){
        return (<div>Logo</div>);
    }
});

let Letra = React.createClass({
    render(){
        return <img className="letra" src={'img/abecedario/'+this.props.el.l.toUpperCase()+'.png'}/>
    },
    componentWillEnter(cb){
        let node = Reactdom.findDOMNode(this);

        var rand = Math.floor(Math.random() * 5);
        node.style.left = (29 + (160 * rand)) + 'px';

        Velocity(node, {
            top: [680, 0]
        }, {
            duration: 740 + Math.random() * 2300,
            complete: ()=> {
                this.props.el.pulsable = false;

                if (this.props.el.pass) {
                    Velocity(node, {
                        opacity: [0, 1],
                        scale: [0, 1]
                    }, {
                        duration: 250
                    })
                } else {

                    CreateAudio('fail.mp3');

                    Velocity(node, 'callout.shake', {
                        duration: 200
                    });
                    Velocity(node, {
                        opacity: [0, 1],
                        scale: [.5, 1]
                    }, {
                        queue: false,
                        duration: 200
                    })
                }
            },
            progress: (els, complete, falta, start, tweenValue)=> {
                if (els[0]) {
                    let n = els[0];
                    let top = parseInt(n.style.top);
                    if (top >= 570) {
                        this.props.el.pulsable = true;
                    }
                }
            }
        });

    },
    componentWillLeave(cb){
        let node = Reactdom.findDOMNode(this);

        //min 585px
        // maximo animación 680px


    }
});

let CreateAudio = (src)=> {
    let a = document.createElement("audio");
    a.src = src;
    document.body.appendChild(a);
    a.play();

};

let End = React.createClass({
    //{{puntos:this.state.puntaje,    frase:this.props.svg.frase}}

    render(){
        return (<div className="end">
            <div className="frase">{this.props.info.frase}</div>
            <div className="point">Resultado: {this.props.info.puntos}</div>
            <div onClick={this.menu}>
                <img className="menuImg" src="img/menu.png"/>
            </div>
        </div>);
    },
    componentWillEnter(cb){
        Velocity(Reactdom.findDOMNode(this), 'transition.bounceIn', {
            duration: 500,
            complete: cb
        })
    },
    menu(){
        let node = Reactdom.findDOMNode(this);
        this.props.hide();
        Velocity(node, 'transition.bounceOut', {
            duration: 500
        })
    }

});

let Game = React.createClass({

    pulse(e){

        let code = e.which;
        let letra = String.fromCharCode(code);
        console.log(letra);
        let falla = true;

        _.forEach(this.state.frases, (l)=> {

            if (!l.pass && l.pulsable && l.l.toLowerCase() == letra.toLowerCase()) {
                l.pass = true;
                if (falla) {
                    falla = false;
                }


                //volver a cero el nodo.
                for (var i = 0; i < Math.round(this.reveal); i++) {
                    let n = this.nodos.pop();
                    if (n) {
                        var s = "translate(0px,0px)";
                        _.assign(n.style, {
                            transform: s
                        });
                    }
                }


            }
        });

        if (falla) {
            CreateAudio('click.wav');
        } else {
            CreateAudio('ok.wav');
        }

    },

    componentDidMount(){
        /*  setInterval(()=> {
         this.setState({nada: Math.random()});
         }, 50);*/
    },

    getInitialState(){


        return {
            puntaje: '0 / 0',
            showEnd: false
        }

    },
    hide(){
        Disarm(this.refs.svg);

        let back = this.refs.svg.querySelector('#back');
        Velocity(back, {
            opacity: [0, 1]
        }, {
            duration: 1000
        });


        Velocity(this.refs.interfaz, {
            opacity: [0, 1]
        }, {
            duration: 1000,
            complete: ()=> {
                this.props.showMenu();
            }
        });

    },
    render(){
        let images = [];
        let frase = "";
        let restante = 100;
        frase = this.props.svg.frase;
        if (this.state.frases) {
            images = this.state.frases.map((el)=> {
                return <Letra key={el.i} el={el}/>
            });

            let i = 0;
            let j = 0;
            _.forEach(this.state.frases, (el)=> {
                j++;
                if (el.pass) {
                    i++;
                }
            });

            let porcentaje = i + ' / ' + this.fraseLen;
            restante = 100 - Math.floor((j * 100 / this.fraseLen));
            this.state.puntaje = ((porcentaje));


        }
        let end;
        if (this.state.showEnd) {
            end = (<End key="end" hide={this.hide} info={{puntos:this.state.puntaje,
                frase:this.props.svg.frase}}/>);
        }


        return (<div className="game">
            <div key="gamedraw" ref="svg" dangerouslySetInnerHTML={{__html:this.props.svg.img}}></div>
            <div className="interfaz perspectiveparent" ref="interfaz">
                <TranGroup>
                    {end}
                </TranGroup>

                <div className="intInner">
                    {frase}
                </div>
                <div className="intInner">
                    Puntaje: {this.state.puntaje}
                </div>
                <div className="intInner">
                    Faltante de frase: {restante + ' %'}
                </div>
                <div className="perspective">
                    <img className="lineas" src="img/lineas.png"/>
                    <TranGroup component="div" className="images">
                        {images}
                    </TranGroup>

                </div>
            </div>
        </div>);
    },

    jugar(){
        let frase = [];
        _.map(this.props.svg.frase, (letra)=> {
            letra = letra.toLowerCase();
            if (letra != '.' && letra != ',' && letra != ' ') {
                let ret;
                if (letra == 'á')
                    ret = "a";
                if (letra == 'é')
                    ret = "e";
                if (letra == 'í')
                    ret = "i";
                if (letra == 'ó')
                    ret = "o";
                if (letra == 'ú')
                    ret = "u";

                if (ret) {
                    letra = ret;
                }

                frase.push(letra);
            }

        });

        frase = frase.reverse();


        _.forEach(frase, (l, i)=> {
            frase[i] = {l, i};
        });
        this.frase = frase;


        let ns = this.refs.svg.querySelectorAll('path,polygon,circle,linearGradient,ellipse,text,linearGradient,rect');
        //console.log(ns.length);
        let nodos = [];
        _.forEach(ns, (it, i)=> {
            nodos.push(it);
        });

        nodos = _.shuffle(nodos);

        this.nodos = nodos;

        window.addEventListener('keydown', this.pulse);
        this.fraseLen = frase.length;

        this.reveal = ns.length / frase.length;

        this.frase.int = setInterval(this.next, this.props.svg.time / frase.length);
        this.setState({
            frases: []
        })
    },
    endGame(){
        this.setState({showEnd: true});
        Velocity(this.refs.intefaz, {
            opacity: [1, 0]
        }, {
            duration: 1000
        })

    },
    next(){
        setTimeout(()=> {
            let el = this.frase.pop();
            if (!el) {
                clearInterval(this.frase.int);
                setTimeout(()=> {
                    toZero(this.refs.svg);
                    this.endGame();
                    window.removeEventListener('keydown', this.pulse);
                }, 2500);

                return;
            }
            this.state.frases.push(el);
            this.setState({
                frases: this.state.frases
            });

        }, Math.random() * 700);
    },
    componentWillAppear(cb){
        console.log('appear game');
        cb();
    },

    componentWillEnter(cb){
        console.log('enter game');
        Disarm(this.refs.svg.querySelector('#draw'));
        setTimeout(()=> {
            toZero(this.refs.svg.querySelector('#draw'));
        }, 100);
        let back = this.refs.svg.querySelector('#back');

        Velocity(back, {
            opacity: [1, 0]
        }, {
            duration: 500,
            complete: cb
        });

        setTimeout(()=> {
            Disarm(this.refs.svg.querySelector('#draw'));
            Velocity(this.refs.interfaz, {
                opacity: [1, 0]
            }, {
                duration: 500,
                complete: cb
            });
        }, 4000);
        setTimeout(()=> {
            this.jugar();
        }, 6500);
    },
    componentWillLeave(cb){
        console.log('leave');
        cb();
    }
});

let reset = (n, i)=> {
    var x, y;
    var temp = 0;
    let r = new Random();
    if (i % 2 == 0) {
        x = r.integer(-2700, -800);
        y = r.integer(-800, 1800);
    } else {
        x = r.integer(800, 1600);
        y = r.integer(-800, 1800);
    }
    x = x + 'px';
    y = y + 'px';
    var s = "translate(" + x + ',' + y + ")";
    _.assign(n.style, {
        transition: 'transform ' + (.2 + Math.random() * 2) + 's ease',
        transform: s
    })
};

let toZero = (mainNode, sel)=> {
    if (typeof sel === 'undefined') {
        sel = 'path,polygon,circle,linearGradient,ellipse,text,linearGradient,rect';
    }
    let ns = mainNode.querySelectorAll(sel);
    _.forEach(ns, (n)=> {
        var s = "translate(0px,0px)";
        _.assign(n.style, {
            transform: s
        })
    });
};

let Disarm = (mainNode)=> {
    let nodes = mainNode.querySelectorAll('path,polygon,circle,linearGradient,ellipse,text,linearGradient,rect');

    _.forEach(nodes, reset);
};

let Niveles = React.createClass({
    render(){
        return (<div className="absolute niveles">
            <img data-index={0} className="level" onClick={this.playLevel} src="img/ciclista.png"/>
            <img data-index={1} className="level" onClick={this.playLevel} src="img/futbol.png"/>
            <img data-index={2} className="level" onClick={this.playLevel} src="img/buho.png"/>
            <img data-index={3} className="level" onClick={this.playLevel} src="img/leon.png"/>

            <div className="back"><img onClick={this.back} src="img/atras.png"/></div>
        </div>);
    },
    back(){
        this.Leave();
        setTimeout(()=> {
            this.props.verP();
        }, 1333)

    },
    playLevel(e){
        this.Leave();
        this.props.hideUp(e);
    },
    componentWillAppear(cb){
        console.log('nivepes appear');
        cb();
    },
    componentWillEnter(cb){
        console.log('nivepes enter');
        let node = Reactdom.findDOMNode(this);
        Velocity(node, {
            opacity: [1, 0]
        }, {
            duration: 500,
            complete: cb
        });
        let nodes = node.querySelectorAll('.level');
        _.forEach(nodes, reset);
        setTimeout(()=> {
            toZero(node, '.level');
        }, 300)
    },
    Leave(cb){
        /*
         Velocity(Reactdom.findDOMNode(this), {
         opacity: [0, 1]
         }, {
         duration: 500,
         complete: cb
         });*/
        let node = Reactdom.findDOMNode(this);
        Velocity(node, {
            opacity: [0, 1]
        }, {
            duration: 1200
        });
        let nodes = node.querySelectorAll('.level');
        _.forEach(nodes, reset);

        //toZero(node, '.level');

    }

});

let Menu = React.createClass({

    getInitialState(){
        return {niveles: false};
    },
    verP(){
        let main = Reactdom.findDOMNode(this);
        let jugar = main.querySelector('#jugar');
        toZero(jugar);
        this.setState({niveles: false});
    },
    render(){
        let menuSvg = fs.readFileSync(__dirname + '/img/menu.svg').toString();


        let nodos = [
            <div key="dibujo" dangerouslySetInnerHTML={{__html:menuSvg}}></div>
        ];
        if (this.state.niveles) {

            nodos.push(<Niveles hideUp={this.hide} verP={this.verP} key="niveles"/>);
        }

        return <TranGroup component="div" className="relative">{nodos}</TranGroup>;
    },
    hide(e){
        console.log('hide menu');
        this.Leave(()=> {
            this.props.jugar(e);
        });

    },
    jugar(){
        this.setState({niveles: true});
        Disarm(this.jugarEl);
    },
    componentWillEnter(cb){
        this.componentWillAppear(cb);
    },
    componentWillAppear(cb){
        let main = Reactdom.findDOMNode(this);
        let draw = main.querySelector('#draw');

        //let nodes = draw.querySelectorAll('path,polygon,circle,linearGradient,ellipse,text,linearGradient,rect');

        let logo = main.querySelector('#logo');
        //let logos = logo.querySelectorAll('path,polygon,circle,linearGradient,ellipse,text,linearGradient,rect');

        let jugar = main.querySelector('#jugar');
        //let jugars = jugar.querySelectorAll('path,polygon,circle,linearGradient,ellipse,text,linearGradient,rect');

        this.jugarEl = jugar;
        jugar.addEventListener('click', this.jugar);
        let back = main.querySelector('#back_1_');
        back.style.opacity = 0;
        Velocity(back, {
            opacity: [1, 0]
        }, {
            duration: 800
        });


        Disarm(draw);
        Disarm(logo);
        Disarm(jugar);
        setTimeout(a=>toZero(draw), 100);
        setTimeout(a=>toZero(logo), 1000);

        if (!this.props.lev) {

            setTimeout(a=>toZero(jugar), 1700);
        } else {
            setTimeout(a=>this.jugar(), 1700);
        }


        setTimeout(a=>cb(), 2000);


        console.log('appear');
    },
    componentWillLeave(cb){
        console.log('leave reacl');
        cb();
    },
    Leave(cb){
        console.log('leave');
        let main = Reactdom.findDOMNode(this);


        let draw = main.querySelector('#draw');

        let logo = main.querySelector('#logo');

        let jugar = main.querySelector('#jugar');

        let back = main.querySelector('#back_1_');
        Velocity(back, {
            opacity: [0, 1]
        }, {
            duration: 800
        });


        Disarm(draw);
        Disarm(logo);
        Disarm(jugar);
        setTimeout(()=> {
            cb();
        }, 1000);
    }


});


Reactdom.render(<App />, document.querySelector('#app'))


