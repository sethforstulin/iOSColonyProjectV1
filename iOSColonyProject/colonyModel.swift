import Foundation

func == (lhs: Cell, rhs: Cell) -> Bool{
    if (lhs.xCoor == rhs.xCoor) && (lhs.yCoor == rhs.yCoor){
        return true
    } else {
        return false
    }
}

struct Cell : CustomStringConvertible, Hashable{
    let xCoor : Int
    let yCoor : Int
    
    func digitLength(num: Int) -> Int{
        var str = String(num)
        return str.characters.count
    }
    
    func power(base: Int, exponent: Int) -> Int {
        var num = base
        for _ in 0..<exponent{
            num *= base
        }
        return num
    }
    
    var description : String {
        return "(\(xCoor), \(yCoor))"
    }
    
    var hashValue: Int {
        return (xCoor * (power(base: 10, exponent: digitLength(num: xCoor) + 2)) + yCoor)
    }//allows colony to be of unlimited size
}


class Colony: CustomStringConvertible {
    
    var gennumb = 0
    var setCells = Set<Cell>()
    var highX = 0
    var highY = 0
    var togWrap = true
    
    init(xSize: Int, ySize: Int){
        self.highX = xSize - 1
        self.highY = ySize - 1
    }
    
    init(size: Int){
        self.highX = size - 1
        self.highY = size - 1
    }
    
    func setCellAlive(xCoor: Int, yCoor: Int){
        setCells.insert(Cell(xCoor: xCoor, yCoor: yCoor))
    }
    
    func setCellDead(xCoor: Int, yCoor: Int){
        setCells.remove(Cell(xCoor: xCoor, yCoor: yCoor))
    }
    
    func resetColony(){
        setCells.removeAll()
    }
    
    var numberLivingCells: Int {
        return setCells.count
    }
    
    func isCellAlive(xCoor: Int, yCoor: Int) -> Bool {
        return setCells.contains(Cell(xCoor: xCoor, yCoor: yCoor))
    }
    
    func getNeighbors(c: Cell) -> Set<Cell> {
        var neighbors = Set<Cell>()
        for x in -1...1{
            for y in -1...1{
                if x != 0 || y != 0 {
                    if isCellAlive(xCoor: c.xCoor + x, yCoor: c.yCoor + y) {
                        neighbors.insert(Cell(xCoor: c.xCoor + x, yCoor: c.yCoor + y))
                    }
                }
            }
        }
        
        if c.yCoor == 0 && togWrap{
            for i in -1...1{
                if isCellAlive(xCoor: c.xCoor + i, yCoor: highY) {
                    neighbors.insert(Cell(xCoor: c.xCoor + i, yCoor: highY))
                }
            }
        }
        
        if c.yCoor == highY && togWrap{
            for i in -1...1{
                if isCellAlive(xCoor: c.xCoor + i, yCoor: 0) {
                    neighbors.insert(Cell(xCoor: c.xCoor + i, yCoor: 0))
                }
            }
        }
        
        if c.xCoor == 0 && togWrap{
            for i in -1...1{
                if isCellAlive(xCoor: highX, yCoor: c.yCoor + i) {
                    neighbors.insert(Cell(xCoor: highX, yCoor: c.yCoor + i))
                }
            }
        }
        
        if c.xCoor == highX && togWrap{
            for i in -1...1{
                if isCellAlive(xCoor: 0, yCoor: c.yCoor + i) {
                    neighbors.insert(Cell(xCoor: 0, yCoor: c.yCoor + i))
                }
            }
        }
        return neighbors
    }
    
    func cneighbors(c: Cell) -> Int {
        return getNeighbors(c: c).count
    }
    
    func evolve(){
        
        var allNeighbors = Set<Cell>()
        var copy = Set<Cell>()
        
        for s in setCells {
            
            for x in -1...1{
                for y in -1...1{
                    allNeighbors.insert(Cell(xCoor: s.xCoor + x, yCoor: s.yCoor + y))
                    
                    if s.yCoor + y > highY  && togWrap {
                        allNeighbors.insert(Cell(xCoor: s.xCoor + x, yCoor: s.yCoor + y - highY - 1))
                    }
                    
                    if s.yCoor + y < 0  && togWrap {
                        allNeighbors.insert(Cell(xCoor: s.xCoor + x, yCoor: s.yCoor + y + highY - 1))
                    }
                    
                    if s.xCoor + x > highX  && togWrap {
                        allNeighbors.insert(Cell(xCoor: s.xCoor + x - highX - 1, yCoor: s.yCoor + y))
                    }
                    
                    if s.xCoor + x < 0  && togWrap {
                        allNeighbors.insert(Cell(xCoor: s.xCoor + x + highX - 1, yCoor: s.yCoor + y))
                    }
                }
            }
        }
        for an in allNeighbors {
            
            var shouldCellBeAlive = false
            
            if cneighbors(c: an) == 3 {
                shouldCellBeAlive = true
            }
            
            if cneighbors(c: an) == 2 {
                if isCellAlive(xCoor: an.xCoor, yCoor: an.yCoor) {
                    shouldCellBeAlive = true
                }
            }
            
            if shouldCellBeAlive {
                copy.insert(Cell(xCoor: an.xCoor, yCoor: an.yCoor))
            }
            
        }
        
        setCells = copy
        
        for i in setCells{
            if (!(0 ... highX).contains(i.xCoor) || !(0 ... highY).contains(i.yCoor)) && togWrap == true {
                setCellDead(xCoor: i.xCoor, yCoor: i.yCoor)
            }
        }
        gennumb += 1
    }
    
    func toggleWrap() {
        if togWrap {
            togWrap == false
        }
        
        if !togWrap {
            togWrap = true
        }
    }
    
    var description: String {
        var outp = ""
        
        for x in 0...highX{
            for y in 0...highY{
                if isCellAlive(xCoor: x, yCoor: y) {
                    outp += "* "
                } else {
                    outp += "- "
                }
            }
            outp += "\n"
        }
        
        return "Generation Number: \(gennumb)\n\(outp)"
    }
    
}
