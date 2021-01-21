import AFD,AFN,Transicion

class Subconjuntos(object):
    def __init__(self, afn):
        self.Destados = {}
        self.afn = afn
        self.afd = AFD.AFD()
        
        
    def e_cerradura(self, estados):
        Tr = self.afn.transiciones
        cerradura = []
        cerradura.append(estados)
        pila = []
        pila.append(estados)
        while len(pila) != 0:
            estado = pila.pop()
            for transicion in Tr:
                if transicion.inicio == estado and transicion.simbolo == 'E':
                    if transicion.fin not in cerradura:
                        cerradura.append(transicion.fin)
                        pila.append(transicion.fin)
        return cerradura
                        
    
    def mover(self,estados,simbolo):
        Tr = self.afn.transiciones
        m = []
        for estado in estados:
            for transicion in Tr:
                if estado == transicion.inicio and transicion.simbolo == simbolo:
                    m.append(transicion.fin)
        return m
                    
                        
    def construir_subconjuntos(self):
        etiqueta = 65
        se_encuentra = False
        self.Destados[str(chr(etiqueta))]=(self.e_cerradura(self.afn.inicial))
        self.Destados[str(chr(etiqueta))].sort()
        self.Destados[str(chr(etiqueta))].append(False)
        while not self.checar_marcados():
            self.Destados[str(chr(etiqueta))][-1] = True
            for simbolo in self.afn.alfabeto:
                U = self.e_cerradura(self.mover(self.Destados[str(chr(
                    etiqueta))][:-1],simbolo))
                U.sort()
                for key,val in self.Destados.items():
                    if all(item in U for item in val):
                       se_encuentra = True
                if not se_encuentra:
                    etiqueta += 1
                    self.Destados[str(chr(etiqueta))]= U
                    self.Destados[str(chr(etiqueta))].append(True)
                    self.afd.agregar_transicion(chr(etiqueta-1),chr(etiqueta),
                                                simbolo)
        for key,val in self.Destados.items():
            if self.afn.inicial in val[:-1]:
                self.afd.establecer_inicial(key)
            for item in self.afn.finales:
                if item in val[:-1]:
                    self.afd.establecer_final(key)
        
                    
    def checar_marcados(self):
        marcados = True
        for key, val in self.Destados.items():
             if val[-1] == False:
                 marcados = False
        return marcados

    def obtener_afd(self):
        return self.afd
            
if __name__ == "__main__":
    autn = AFN.AFN()
    autn.cargar_desde("afn.afn")
    autn.cargar_transiciones()
    autn.obtener_inicial()
    autn.obtener_finales()
    autn.obtener_alfabeto()
    subconjuntos = Subconjuntos(autn)
    subconjuntos.construir_subconjuntos()
    autd = AFD.AFD()
    autd = subconjuntos.obtener_afd()
    autd.guardar_en("afd")