
const app = new Vue({
    el: "main",
    template: `
    <div class="background">
        <footer class="responsive">
            <img src="icones/eyes.png" alt="">
            <h1>DESACORDADO</h1>
            <div class="wait" v-if="coma">
                <p>AGUARDE</p>
                <p class="special">{{count}} SEGUNDOS</p>
                <p>PARA RENASCER</p>

            </div>
            <div class="busted" v-if="busted">
                <p>PRESSIONE</p>
                <p class="special">G</p>
                <p>PARA RENASCER</p>
            </div>
        </footer>
    </div>
    `,
    data: {
        count: 1200,
        coma: false,
        loop: "",
        busted: false,
        Emergency : {},
        blocked : false,
    },

    methods: {
            
        async startCount(){
            if(!this.coma){
                await this.haveCops()
                this.coma = true
                document.body.style.visibility = "visible"
                document.body.style.display = "block"
                this.loop = setInterval(() => {
                    if (this.count > 0){
                        this.count -= 1
                        if (this.count == 0){
                            axios
                            .post("https://survival/atualizeInfo")
                            this.disableComa()
                            this.busted = true
                        }
                    }
                }, 1000);
            }
        },

        async haveCops(){
            this.Emergency.minimum = (await axios.post("https://survival/haveCops",{})).data
        },

        disableComa(){
            this.coma = false
            this.count = 1200
            clearInterval(this.loop);
        },

        protectionBusted(){
            document.body.style.visibility = "visible"
            document.body.style.display = "block"
            this.busted = true
        },

        hideNui(){
            document.body.style.visibility = "hidden"
            document.body.style.display = "none"  
            this.busted = false
            this.Emergency = {}
            this.disableComa()
        }
    },

    created() {
        
        window.addEventListener('message',function(event){
            var item = event.data;
            if ( item.coma == false) {
                app.disableComa()
            } else if (item.coma == true) {
                app.startCount()
            } else if (item.action == "hide"){
                app.hideNui()
            }  else if (item.emergencyAccept) {
                app.Emergency.accept = true
            }
        });
       
    },

})