import re
import Transicion

class AFD(object):
    def __init__(self):
        self.inicial= ""
        self.finales = []
        self.transiciones = []
        self.definicion = ""
    

    def cargar_desde(self,fname):
        ##abrimos el archivo
        f = open(fname,encoding='utf-8')
        ##obtenemos el texto
        self.definicion = f.read()
        f.close()
        
    def list_string(self, s):  
        str1 = ""  
        for ele in s:  
            str1 += " " + str(ele)   
        return str1 
        
    def guardar_en(self,fname):
        self.definicion = "inicial:{}\nfinales:{}".format(self.inicial,
                                                          self.list_string(
                                                              self.finales))
        for tr in self.transiciones:
            atr = tr.obtener_atributos()
            self.definicion += "\n{}->{},{}".format(atr[0], atr[1],atr[2])
        f = open(fname+".afd",'w',encoding = 'utf-8')
        f.write(self.definicion)
        f.close()
        
    def obtener_lenguaje(self):
        simbolos=[]
        for linea in self.definicion.splitlines():
            simbolo=""
            if re.match(r"(\d+)->(\d+),([a-zE])",linea):
                res = re.match(r"(\d+)->(\d+),([a-zE])",linea)
                simbolo = res.group(3)
                simbolos.append(simbolo)
        simbolos = list(dict.fromkeys(simbolos))
        print(simbolos)
        
    def cargar_transiciones(self):
        for linea in self.definicion.splitlines():
            inicio=0
            fin=0
            simbolo=""
            if re.match(r"([A-Z]?)->([A-Z]?),([a-z])",linea):
                res = re.match(r"([A-Z]?)->([A-Z]?),([a-z])",linea)
                inicio = res.group(1)
                fin = res.group(2)
                simbolo = res.group(3)
                tr = Transicion.Transicion(inicio,fin,simbolo)
                self.transiciones.append(tr)
                
    def agregar_transicion(self,inicio,fin,simbolo):
        tr = Transicion.Transicion(inicio,fin,simbolo)
        self.transiciones.append(tr)

    def eliminar_transicion(self,inicio,fin,simbolo):
        tr = Transicion.Transicion(inicio,fin,simbolo);
        indice = 0
        for transicion in self.transiciones:
            if transicion.igual(tr):
                self.transiciones.pop(indice)        
                return
            indice += 1
    
    def obtener_inicial(self):
        lineas = self.definicion.splitlines()
        ini_str = re.match(r"([a-zA-z]+):(\d+)",lineas[0])
        self.inicial = ini_str.group(2)
        
    def obtener_finales(self):
        lineas = self.definicion.splitlines()
        ini_str = re.match(r"([a-zA-z]+):(\s*\d+)+",lineas[1])
        finales = ini_str.group(2).split(" ")
        for final in  finales:
            self.finales.append(final)
        
    def establecer_inicial(self,inicial):
        self.inicial= inicial
        
    def establecer_final(self,final):
        self.finales.append(final)
        
    def es_AFN(self):
        for transicion in self.transiciones:
            if transicion.obtener_atributos()[2] == 'E':
                return True
        return False
    
    def es_AFD(self):
        for transicion in self.transiciones:
            if transicion.obtener_atributos()[2] == 'E':
                return False
        return True
    
    '''
    def acepta(self, cadena):
    def generar_cadena(self)
    
                
if __name__ == "__main__":
    autd = AFD()
    autd.cargar_desde("afn.afn")
    autd.cargar_transiciones()
    autd.agregar_transicion(2,3,'E')
    autd.eliminar_transicion(11,11,'b')
    autd.obtener_inicial()
    autd.obtener_finales()
    autd.establecer_inicial(4)
    autd.establecer_final(8)
    autd.guardar_en("afn2")'''