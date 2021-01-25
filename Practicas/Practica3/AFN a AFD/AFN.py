import re
import Transicion

class AFN(object):
    def __init__(self):
        self.inicial=0
        self.finales = []
        self.transiciones = []
        self.definicion = ""
        self.alfabeto=[]
    

    def cargar_desde(self,fname):
        ##abrimos el archivo
        f = open(fname,encoding='utf-8')
        ##obtenemos el texto
        self.definicion = f.read()
        f.close()
        
    def obtener_alfabeto(self):
        simbolos=[]
        for linea in self.definicion.splitlines():
            simbolo=""
            if re.match(r"(\d+)->(\d+),([a-zE])",linea):
                res = re.match(r"(\d+)->(\d+),([a-zE])",linea)
                simbolo = res.group(3)
                simbolos.append(simbolo)
        simbolos = list(dict.fromkeys(simbolos))
        simbolos.remove('E')
        self.alfabeto = simbolos
        
        
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
        f = open(fname+".afn",'w',encoding = 'utf-8')
        f.write(self.definicion)
        f.close()
        
    def cargar_transiciones(self):
        for linea in self.definicion.splitlines():
            inicio=0
            fin=0
            simbolo=""
            if re.match(r"(\d+)->(\d+),([a-zE])",linea):
                res = re.match(r"(\d+)->(\d+),([a-zE])",linea)
                inicio = int(res.group(1))
                fin = int(res.group(2))
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
        self.inicial = int(ini_str.group(2))
        
    def obtener_finales(self):
        lineas = self.definicion.splitlines()
        ini_str = re.match(r"([a-zA-z]+):(\s*\d+)+",lineas[1])
        finales = ini_str.group(2).split(" ")
        for final in  finales:
            self.finales.append(int(final))
        
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
    autn = AFN()
    autn.cargar_desde("afn.afn")
    autn.cargar_transiciones()
    autn.agregar_transicion(2,3,'E')
    autn.eliminar_transicion(11,11,'b')
    autn.obtener_inicial()
    autn.obtener_finales()
    autn.establecer_inicial(4)
    autn.establecer_final(8)
    autn.guardar_en("afn2")'''
