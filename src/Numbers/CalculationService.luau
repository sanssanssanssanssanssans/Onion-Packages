--[[

제가 만든것이 아닙니다.

]]

local CalculationService = {}
-- please write percentage as a number 20% -> 0.20

-- The Average is calculated by the relative Amount/Absolute Total Amount and Total Amount
function CalculationService:CalculateAverage(TableWithNumbers: SharedTable): number
	local TotalAmount = 0
	local AbsoluteTotalAmount = 0
	local index = 1
	local average
	while #TableWithNumbers >= 1 do
		TotalAmount += 1
		AbsoluteTotalAmount = TableWithNumbers[index] + AbsoluteTotalAmount
		table.remove(TableWithNumbers, index)
	end
	average = AbsoluteTotalAmount / TotalAmount
	return average, AbsoluteTotalAmount, TotalAmount
end

function CalculationService:CalculateVelocity(distance: number, timenum: number): number
	local velocityOfPart = distance / timenum
	return velocityOfPart
end

function CalculationService:CalculateTime(distance: number, velocity: number): number
	local Time = distance / velocity
	return Time
end

function CalculationService:CalculateDistance(velocity: number, timenum: number): number
	local Displacement = velocity * timenum
	return Displacement
end

-- Cath = cathetus or leg ~= Hypotenuse
-- Opposite Leg = Opposite side of angles face
-- Adjacent Leg = Adjacent side to angles face (practically next to the face which is not the Hypotenuse)
-- Hypotenuse = Opposite of the 90° angle

function CalculationService:CalculateSinAngle(OppositeCath: number, hypotenuse: number): number
	local angle = math.asin(OppositeCath / hypotenuse)
	return angle
end

function CalculationService:CalculateSinMissingHypotenuse(angle: number, OppositeCath: number): number
	local MissingHypotenuse = OppositeCath / math.sin(angle)
	return MissingHypotenuse
end

function CalculationService:CalculateSinMissingOppositeCath(angle: number, hypotenuse: number): number
	local MissingOppositeCath = math.sin(angle) * hypotenuse
	return MissingOppositeCath
end

function CalculationService:CalculateCosAngle(AdjacentCath: number, hypotenuse: number): number
	local angle = math.acos(AdjacentCath / hypotenuse)
	return angle
end

function CalculationService:CalculateCosMissingHypotenuse(angle: number, AdjacentCath: number): number
	local MissingHypotenuse = AdjacentCath / math.cos(angle)
	return MissingHypotenuse
end

function CalculationService:CalculateCosMissingAdjacentCath(angle: number, hypotenuse: number): number
	local MissingNearCath = math.cos(angle) * hypotenuse
	return MissingNearCath
end

function CalculationService:CalculateTanAngle(AdjacentCath: number, OppositeCath: number): number
	local angle = math.atan(AdjacentCath / OppositeCath)
	return angle
end

function CalculationService:CalculateTanMissingOppositeCath(angle: number, AdjacentCath: number): number
	local MissingOppositeCath = AdjacentCath / math.tan(angle)
	return MissingOppositeCath
end

function CalculationService:CalculateTanMissingAdjacentCath(angle: number, OppositeCath: number): number
	local MissingNearCath = math.tan(angle) * OppositeCath
	return MissingNearCath
end

function CalculationService:CalculateHypotenusePythagoreanTheorem(a: number, b: number): number
	local c = math.sqrt(a^2 + b^2)
	return c
end

function CalculationService:CalculateCathetusPythagoreanTheorem(b: number, c: number): number
	local a = math.sqrt(c^2 - b^2)
	return a
end

-- I didn't really found a good word for CoreValue in my language, basically the StartValue of smth
-- NewValue = CoreValue but changed
-- REMEMBER: PLEASE PUT PERCENTAGE AS A NUMBER 20% -> 0.20

function CalculationService:CalculatePercentage(CoreValue: number, NewValue: number): number
	local percentage = NewValue / CoreValue * 100
	return percentage
end

function CalculationService:CalculateNewValue(CoreValue: number, percentageAsDecimal: number): number
	local NewValue = CoreValue * percentageAsDecimal / 100
	return NewValue
end

function CalculationService:CalculateCoreValue(NewValue: number, percentageAsDecimal: number): number
	local CoreValue = NewValue / percentageAsDecimal * 100
	return CoreValue
end

function CalculationService:PriceDecrease(percentageAsDecimal: number, CoreValue: number): number
	local NewPercentage =  1 - percentageAsDecimal
	local NewValue = CoreValue * NewPercentage
	return NewValue
end

function CalculationService:PriceIncrease(percentageAsDecimal: number, CoreValue: number): number
	local NewPercentage = 1 + percentageAsDecimal
	local NewValue = CoreValue * NewPercentage
	return NewValue
end

function CalculationService:CalculateAreaTriangle(ground: number, height: number): number
	-- ground is sort of the bottom of a triangle
	local area = (ground * height) / 2
	return area
end

function CalculationService:CalculateAreaOfaTriangle(a: number, b: number, c: number): number
	local circ = a + b + c
	return circ
end

function CalculationService:CalculateAreaOfaSquare(a: number, b:number): number
	-- a is one side and b is another
	local area
	if a or b <= 0 then
		error("Number(s) must be greater than 0")
	end
	if a == b then
		-- if a is equal to b its a squared
		area = a^2
	else
		area = a * b
	end
	return area
end

function CalculationService:CalculateCircumeferenceOfASquare(a: number, b: number): number
	local circ
	if a == b then
		circ = 4 * a
	else
		circ = 2 * a + 2 * b
	end
	
	return circ
end

-- Circumfrence are all the sides added together, so if a squares side is 4cm (so 4 4cm sides) it'd be 4+4+4+4 or 4*4 or 16

function CalculationService:CalculateCircumfrenceOfACircle(radius: number): number
	-- you can also calculate 2 * pi * radius
	local diameter = radius * 2
	local Circumfrence = diameter * math.pi
	return Circumfrence
end


function CalculationService:CalculateRadiusofCircleCircumfrence(circumfrence: number): number
	local radius = circumfrence / (2 * math.pi)
	return radius	
end

function CalculationService:CalculateAreaOfACircle(radius: number): number
	-- if you only have a diameter, divide it by 2
	local area = math.pi * radius^2
	return area
end

-- (Surface-) area: the overall area of an object

function CalculationService:CalculateAreaofACylinder(area: number, surfaceArea: number): number
	local SurfaceArea = 2 * area + surfaceArea
	return SurfaceArea
end

-- Volume: 3D space occupied by an object

function CalculationService:CalculateVolumeInACylinder(area: number, height: number): number
	local Volume = area * height
	return Volume
end

function CalculationService:CalculateRadiusWithCylinderVolume(Volume: number, Height: number): number
	local radius = math.sqrt(Volume / math.pi * Height)
	return radius
end

-- a cone is divided in two piece: the surface area [M] and a circle [G]

function CalculationService:CalculateConeVolume(radius: number, height: number): number
	local Volume = 1 / 3 * math.pi * radius^2 * height
	return Volume
end

-- s is the side of the cone, or like the diagonal side
function CalculationService:CalculateConeSurfaceArea(side: number, radius: number): number
	local area = math.pi * radius * side
	return area
end

-- an arc is a piece of a circle, you can imagine it like this -> <)

function CalculationService:CalculateArcLength(radius: number, angle: number): number
	local arclength = 2 * math.pi * radius * (angle / 360)
	return arclength
end

function CalculationService:CalculateArcSurfaceArea(radius: number, angle: number): number
	local arcarea = math.pi * radius^2 * (angle / 360)
	return arcarea
end

function CalculationService:CalculateArcAngle(radius: number, surfaceArea: number): number
	local angle = (surfaceArea * 360) / (math.pi * radius^2)
	return angle
end

function CalculationService:CalculateRadiusWithArc(angle: number, surfaceArea: number): number
	local radius = math.sqrt((surfaceArea * 360) / (math.pi * angle))
	return radius
end

function CalculationService:CalculateSphereSurfaceArea(radius: number): number
	local Area = 4 * math.pi * radius^2
	return Area
end

function CalculationService:CalculateSphereVolume(radius: number): number
	local Volume =  4 / 3 * math.pi * radius^3
	return Volume
end


-- A Circle Ring consists of two radius, inner and outer radius

function CalculationService:CalculateCircleRing(radius1: number, radius2: number): number
	if radius2 <= radius1 then error("Second radius must be greater than first radius") end
	local Ring = math.pi * (radius2^2 - radius1^2)
	return Ring
end

-- If you "unfold" a pyramid, you get 4 triangles and 1 square
-- The square is called "Base"
function CalculationService:CalculatePyramidSurfaceArea(BaseLength: number, HeightOfTriangle: number): number
	local AreaOfTriangles = CalculationService:CalculateAreaTriangle(BaseLength, HeightOfTriangle)
	local Area = BaseLength^2 + 4 * AreaOfTriangles
	return Area
end

function CalculationService:CalculatePyramidVolume(BaseArea: number, HeightOfTriangle: number): number
	local Volume = 1 / 3 * BaseArea * HeightOfTriangle
	return Volume
end

function CalculationService:CalculateTrapezoidSurfaceArea(ground: number, top: number, height: number): number
	local Area = 1/2 * (ground + top) * height
	return Area
end

-- n equals to the amount of time that has passed since the startValue/CoreValue, so like **5** Minutes
-- Factor is how much has increased, so like 20% (or 0.20)

function CalculationService:ExponentialIncrease(n: number, FactorAsDecimal: number, CoreValue: number): number	
	local newPercentage = 1 + FactorAsDecimal
	local An = CoreValue * newPercentage^n
	return An
end

function CalculationService:ExponentialDecrease(n: number, FactorAsDecimal: number, CoreValue: number): number
	local newPercentage = 1 - FactorAsDecimal
	local An = CoreValue * newPercentage^n
	return An
end

-- thanks Mp3Alt for solving an error here :)
function CalculationService:CalculateFactorNinExponentialIncrease(FactorAsDecimal: number, StartValue: number, EndValue: number): number
	local n = 0
	if StartValue >= EndValue then
		error("StartValue must be smaller than EndValue")
	end

	local Factor = 1 + FactorAsDecimal
	local PreviousNumber = StartValue

	while PreviousNumber < EndValue do
		n = n + 1
		local CurrentNumber = PreviousNumber * Factor
		if CurrentNumber > EndValue then
			break
		end

		PreviousNumber = CurrentNumber
	end

	return n
end

function CalculationService:CalculateFactorNinExponentialDecrease(FactorAsDecimal: number, StartValue: number, EndValue: number): number
	local n = 0
	if StartValue <= EndValue then
		error("StartValue must be greater than EndValue")
	end

	local Factor = 1 - FactorAsDecimal
	local PreviousNumber = StartValue

	while PreviousNumber >= EndValue do
		n = n + 1
		local CurrentNumber = PreviousNumber * Factor
		if CurrentNumber <= EndValue then
			break
		end
		
		PreviousNumber = CurrentNumber
	end

	return n
end

-- Rule of Three is making it possible to make extra steps to get an EndNumber which was not found out yet
function CalculationService:RuleOfThree(StartValue: number, MissingStartNumber: number, EndValue: number): number
	local FirstValue = StartValue / StartValue -- Equal to 1
	local FirstNumber = MissingStartNumber / StartValue
	local SecondValue = FirstValue * EndValue -- Equals to EndValue
	local SecondMissingNumber = FirstNumber * EndValue
	
	return SecondMissingNumber
end


-- m is an exponent, same as n
-- if a^m * or / a^n then it equals to a^(m + or - n) (* -> +, / -> -)
function CalculationService:LawsOfExponentsProductOfPower(a: number, m: number, n: number): number
	local Whole = a^(m + n)
	return Whole
end

function CalculationService:LawsOfExponentsQuotientOfPower(a: number, m: number, n: number): number
	local Whole = a^(m - n)
	return Whole
end

-- if a^n * or / b^n then it equals to (a * or / b)^n (* -> *, / -> /)
function CalculationService:LawsOfExponentProductPowerRule(a: number, b: number, n: number): number
	local Whole = (a * b)^n
	return Whole
end

function CalculationService:LawsOfExponentsQuotientPowerRule(a: number, b: number, n: number): number
	local Whole = (a / b)^n
	return Whole
end

-- Power of a Power Rule (a^m)^n
function CalculationService:LawsOfExponentsPowerOfAPower(a: number, m: number, n:number): number
	local Whole = a^ (m * n)
	return Whole
end 

function CalculationService:LawsOfExponentsNegativeExponent(a: number, n: number): number
	local Whole = 1 / a^n
	return Whole
end

-- n here is the exponent of a square root, cube root, quad root...
-- if sqrt(a) * sqrt(b) it equals to sqrt(a * b)
-- the reason there is no math.sqrt is due to Roblox not having a custom sqrt exponent function, this is equal to a custom sqrt
function CalculationService:LawsOfRadicalsProductOfRadicals(a: number, b: number, n:number): number
	local num = a * b
	local Whole = num^(1 / n)
	return Whole
end

-- same thing here, only with division
function CalculationService:LawsOfRadicalsQuotientOfRadicals(a: number, b: number, n:number): number
	if b <= 0 then error("Second number (b) must be greater than 0") end
	local num = a / b
	local Whole = num^(1 / n)
	return Whole
end

-- example: nsqrt(msqrt(a))
function CalculationService:LawsOfRadicalsSquareRootInASquareRoot(a: number, m: number, n: number): number
	local exponents = m * n
	local Whole = a^(1 / exponents)
	return Whole
end

-- example: (nsqrt(a))^m, this is also equal to nsqrt(a^m)
function CalculationService:LawsOfRadicalsSquareRootInExponent(a: number, m: number, n: number): number
	local exponents = m / n
	local Whole = a^(1 / exponents)
	return Whole
end

--Factorial is when a start number counts down and multiplies with the next number
-- ! is used for factorials
-- example: 5! -> 5 * 4 * 3 * 2 * 1 -> 120

function CalculationService:Factorial(FactorNumber: number): number
	local Factorial = 1

	for i = 1, FactorNumber, 1 do
		Factorial = Factorial * i
	end

	return Factorial
end

--[[Subfactorials are when you have a set of numbers and you want to find how many ways they can be arranged without any number being 
in its original position]]
function CalculationService:Subfactorial(n: number): number
	if n == 0 then
		return 1
	elseif n == 1 then
		return 0
	else
		return (n - 1) * (CalculationService:Subfactorial(n - 1) + CalculationService:Subfactorial(n - 2))
	end
end

-- 5's trick is used here
-- Basically what's happening here is we divide the factorial number with 5^n until the outcome is lower than 1
-- The result is how many 0 are in the end number (5! for example has only 1 zero (120))
function CalculationService:FactorialZeros(FactorNumber: number): number
	local t = {}
	local n = 1
	local endSum
	local wholeInteger = 0
	
	while true do
		endSum = FactorNumber / 5^n
		if endSum < 1 then
			break
		end
		
		table.insert(t, endSum)
		
		n += 1
	end
	-- math.modf returns two values: Integer, decimal
	for i, number in pairs(t) do
		wholeInteger = wholeInteger + math.modf(number)
	end
	
	return wholeInteger
end

-- example: x^2 + 2x + 4
-- p in this example is 2 AND ONLY 2, not 2x
-- q in this example is 4
-- The forumala is -(p) / 2 +- sqrt( (p/2)^2 - (q) )
-- There are always two results

function CalculationService:QuadraticFormula(p: number, q: number): number
	local FirstPart = -(p) / 2
	local SecondPart = (p / 2)^2 -(q)
	local x1 = FirstPart + math.sqrt(SecondPart)
	local x2 = FirstPart - math.sqrt(SecondPart)
	
	return x1, x2
end

-- example: 2^2^2 = 16
-- Calculation: We only calculate what 2^2 is, which is four and since we have one more two to calculate, this would be 2^4
-- here is a general look how tetration is: x^x^x
-- Level (or sometimes Height) refers is basically x here

function CalculationService:Tetration(Level: number): number
	local Result = Level ^ Level ^ Level
	return Result
end

-- Example: 1 / 100 -> P1 / P2
--[[Another example: In a box, there are 5 red triangles and 10 blue triangles, you want a red triangle
but you are not allowed to peak in the box, so you must grab a triangle randomly.]]
-- P1 is the first amount that is the "success" amount. In the example, it would be 5
-- P2 is the total amount of something. In the example it would 5 + 10, so 15 is the total amount

function CalculationService:ProbabilityTheory(P1: number, P2: number): number
	local Probability = P1 / P2
	return Probability
end

-- Checks if the number can only be divide with itself or 1
-- By the way an easier way to explain prime numbers is just that if the number can not divide with something to get a whole Integer
-- For 3, as an example, 3 doesn't have a number that can divide with it to get a whole Integer, so 3 is prime
-- But for 6, 6 can be divided by 2 and 3 (6 / 2 = 3) (6 / 3 = 2) and the result is a whole Integer, making 6 not a prime

function CalculationService:isPrime(num): boolean
	if num < 2 then
		return false
	end
	for i = 2, math.sqrt(num) do
		if num % i == 0 then
			return false
		end
	end
	return true
end

-- "rank" is basically what order a prime number is. Rank 21 = 73
function CalculationService:GetPrimeNumberWithRank(rank: number): number
	local PrimeRank = 1
	local candidate = 2

	while PrimeRank < rank do
		candidate = candidate + 1
		if CalculationService:isPrime(candidate) then
			PrimeRank = PrimeRank + 1
		end
	end

	return candidate
end

-- Set your own root here
-- Exponent: 2 = square root, 3 = cube root, 4 = quad root etc.

function CalculationService:CustomRoot(exponent: number, Number: number): number
	local CustomRoot = Number^(1 / exponent)
	return CustomRoot
end

-- Binomial Formula is just used for efficency

-- First Binomal Formula: (a + b)^2
-- -> a^2 + 2ab + b^2

function CalculationService:FirstBinomialFormula(a: number, b: number): number
	local Result = a^2 + 2*(a * b) + b^2
	return Result
end

-- Second Binomal Formula: (a - b)^2
-- -> a^2 - 2ab * b^2

function CalculationService:SecondBinomialFormula(a: number, b: number): number
	local Result = a^2 - 2*(a * b) * b^2
	return Result
end

-- Third Binomal Formula: (a + b) * (a - b)
-- -> a^2 - b^2

function CalculationService:ThirdBinomialFormula(a: number, b: number): number
	local Result = a^2 - b^2
	return Result
end

function CalculationService:LinearInterpolation(a: number, b: number, t: number): number
	local Result = a + (b - a) * t
	return Result
end

-- UTCOffset in hours UTC + 2 for example = GMT (Greenwich Mean Time)
-- + 2 is the Offset

function CalculationService:GetTimeZone(UTCOffset: number): number
	local NewTime = DateTime.now()
	local UTCNewTime = NewTime:ToUniversalTime()
	local SetNewHour = UTCNewTime.Hour + (UTCOffset)
	return SetNewHour, UTCNewTime.Minute, UTCNewTime.Second
end

-- Matrix Operations

-- A matrix has to be written like this in order to work:

--[[
{1, 2}, 1
{4, 5}, 2
{6, 7}  3
 1   2
]]

-- = 3 x 2
-- MAKE SURE TO WRITE THEM LIKE THIS!!!! { {numbers}, {numbers},... }

-- This how it works: A matrix consists of two things columns and rows
-- Rows are how many "tables" exist inside the matrix
-- Colums show how many numbers are in one row
-- Rows are written first then columns
-- Matrices in addition/subtraction must have the same dimension

-- Transposing is just "tilting" the columns and the rows and changing the order of the number

function CalculationService:MatrixTranspose(matrix: {}): {}
	local numRows = #matrix
	local numCols = #matrix[1]

	local transposedMatrix = {}

	for i = 1, numCols do
		transposedMatrix[i] = {}
		for j = 1, numRows do
			transposedMatrix[i][j] = matrix[j][i]
		end
	end

	return transposedMatrix
end

function CalculationService:MatrixAdd(matrix1: {}, matrix2: {}): {}
    local numRows1, numCols1 = #matrix1, #matrix1[1]
    local numRows2, numCols2 = #matrix2, #matrix2[1]

    if numRows1 ~= numRows2 or numCols1 ~= numCols2 then
        error("Matrices must have the same dimensions for addition.")
    end

    local resultMatrix = {}

    for i = 1, numRows1 do
        resultMatrix[i] = {}
        for j = 1, numCols1 do
            resultMatrix[i][j] = matrix1[i][j] + matrix2[i][j]
        end
    end

    return resultMatrix
end

function CalculationService:MatrixSubtract(matrix1: {}, matrix2: {}): {}
	local numRows1, numCols1 = #matrix1, #matrix1[1]
	local numRows2, numCols2 = #matrix2, #matrix2[1]

	if numRows1 ~= numRows2 or numCols1 ~= numCols2 then
		error("Matrices must have the same dimensions for subtraction.")
	end

	local resultMatrix = {}

	for i = 1, numRows1 do
		resultMatrix[i] = {}
		for j = 1, numCols1 do
			resultMatrix[i][j] = matrix1[i][j] - matrix2[i][j]
		end
	end

	return resultMatrix
end

function CalculationService:MatrixMultiply(matrix1: {}, matrix2: {}): {}
	local numRows1, numCols1 = #matrix1, #matrix1[1]
	local numRows2, numCols2 = #matrix2, #matrix2[1]

	if numCols1 ~= numRows2 then
		error("Number of columns in matrix1 must be equal to the number of rows in matrix2 for multiplication.")
	end

	local resultMatrix = {}

	for i = 1, numRows1 do
		resultMatrix[i] = {}
		for j = 1, numCols2 do
			local sum = 0
			for k = 1, numCols1 do
				sum = sum + matrix1[i][k] * matrix2[k][j]
			end
			resultMatrix[i][j] = sum
		end
	end

	return resultMatrix
end

-- Calculates the determinant of a square matrix in a recursion

function CalculationService:MatrixDeterminant(matrix: {}): {}
	local numRows, numCols = #matrix, #matrix[1]

	-- Check if the matrix is square
	if numRows ~= numCols then
		error("Matrix must be square for determinant calculation.")
	end

	-- Base case: determinant of a 1x1 matrix
	if numRows == 1 then
		return matrix[1][1]
	end

	local det = 0

	for col = 1, numCols do
		local sign = (col % 2 == 1) and 1 or -1
		local minorMatrix = self:MatrixMinor(matrix, 1, col)
		det = det + sign * matrix[1][col] * self:MatrixDeterminant(minorMatrix)
	end

	return det
end


-- Calculates the minor of a matrix by removing a specified row and column.

function CalculationService:MatrixMinor(matrix: {}, rowToRemove: number, colToRemove: number): {}
	local numRows, numCols = #matrix, #matrix[1]

	-- Check if the specified row and column are valid
	if rowToRemove < 1 or rowToRemove > numRows or colToRemove < 1 or colToRemove > numCols then
		error("Invalid row or column used for matrix minor.")
	end

	local minorMatrix = {}

	for i = 1, numRows do
		if i ~= rowToRemove then
			minorMatrix[#minorMatrix + 1] = {}
			for j = 1, numCols do
				if j ~= colToRemove then
					minorMatrix[#minorMatrix][#minorMatrix[#minorMatrix] + 1] = matrix[i][j]
				end
			end
		end
	end

	return minorMatrix
end

-- Calculates the adjugate of a matrix

function CalculationService:MatrixAdjugate(matrix: {{  }}): {}
	local numRows, numCols = #matrix, #matrix[1]

	local resultMatrix = {}

	for i = 1, numRows do
		resultMatrix[i] = {}
		for j = 1, numCols do
			local minorMatrix = self:MatrixMinor(matrix, i, j)
			local cofactor = ((i + j) % 2 == 0) and 1 or -1
			resultMatrix[i][j] = cofactor * self:MatrixDeterminant(minorMatrix)
		end
	end

	return self:MatrixTranspose(resultMatrix)
end

-- Calculates the inverse of a square matrix using the adjugate matrix.

function CalculationService:MatrixInverse(matrix: {}): {}
	local numRows, numCols = #matrix, #matrix[1]

	-- Check if the matrix is square
	if numRows ~= numCols then
		error("Matrix must be square for inversion.")
	end

	-- Check if the determinant is non-zero
	local determinant = self:MatrixDeterminant(matrix)
	if determinant == 0 then
		error("Matrix is not invertible (determinant is zero).")
	end

	-- Calculate the inverse using the adjugate matrix
	local adjugateMatrix = self:MatrixAdjugate(matrix)
	local scalar = 1 / determinant

	local resultMatrix = {}

	for i = 1, numRows do
		resultMatrix[i] = {}
		for j = 1, numCols do
			resultMatrix[i][j] = adjugateMatrix[i][j] * scalar
		end
	end

	return resultMatrix
end

-- Approximates the area under a curve by dividing it into narrow rectangles.
-- f is your function you wanna use
-- credits to @TheBrainy06 for pointing out function custimisation

function CalculationService:RectangularRule(f: (x: number) -> number, a: number, b: number, n: number): number
	local h = (b - a) / n
	local integral = 0

	for i = 1, n do
		local x_i = a + (i - 0.5) * h
		integral = integral + f(x_i) * h
	end

	return integral
end

-- Estimates the area under a curve using a trapezoid formed by two adjacent points.

function CalculationService:TrapezoidalRule(f: (x: number) -> number ,a: number, b: number): number
	local Result = (b - a) * (f(a) + f(b)) / 2
	return Result
end

-- This is a really huge "table" of functions, I hope everything is calculated right
-- If you find any errors, please let me know!

function CalculationService:ConvertSecondsToMinutes(seconds: number): number
	local minutes = seconds / 60
	return minutes
end

function CalculationService:ConvertSecondsToDays(seconds: number): number
	local days = seconds / (24 * 60 * 60)
	return days
end

function CalculationService:ConvertSecondsToHours(seconds: number): number
	local hours = seconds / 3600
	return hours
end

function CalculationService:ConvertSecondsToMonths(seconds: number): number
	local daysInMonth = 30.42
	local months = seconds / (daysInMonth * 24 * 60 * 60)
	return months
end

function CalculationService:ConvertSecondsToYears(seconds: number): number
	local daysInYear = 365
	local years = seconds / (daysInYear * 24 * 60 * 60)
	return years
end

function CalculationService:ConvertMinutesToSeconds(minutes: number): number
	local seconds = minutes * 60
	return seconds
end

function CalculationService:ConvertMinutesToHours(minutes: number): number
	local hours = minutes / 60
	return hours
end

function CalculationService:ConvertMinutesToDays(minutes: number): number
	local days = minutes / (24 * 60)
	return days
end

function CalculationService:ConvertMinutesToMonths(minutes: number): number
	local daysInMonth = 30.42
	local months = minutes / (24 * 60 * daysInMonth)
	return months
end

function CalculationService:ConvertMinutesToYears(minutes: number): number
	local years = minutes / (365 * 24 * 60)
	return years
end

function CalculationService:ConvertHoursToSeconds(hours: number): number
	local seconds = hours * 3600
	return seconds
end

function CalculationService:ConvertHoursToMinutes(hours: number): number
	local minutes = hours * 60
	return minutes
end

function CalculationService:ConvertHoursToDays(hours: number): number
    local days = hours / 24
    return days
end

function CalculationService:ConvertHoursToMonths(hours: number): number
	local daysInMonth = 30.42
	local months = hours / (24 * daysInMonth)
	return months
end

function CalculationService:ConvertHoursToYears(hours: number): number
	local daysInYear = 365
	local years = hours / (24 * daysInYear)
	return years
end

function CalculationService:ConvertDaysToSeconds(days: number): number
	local seconds = days * 24 * 60 * 60
	return seconds
end

function CalculationService:ConvertDaysToMinutes(days: number): number
	local minutes = days * 24 * 60
	return minutes
end

function CalculationService:ConvertDaysToHours(days: number): number
	local hours = days * 24
	return hours
end

function CalculationService:ConvertDaysToMonths(days: number): number
	local monthsInYear = 12
	local months = days / (30.42 / monthsInYear)
	return months
end

function CalculationService:ConvertDaysToYears(days: number): number
	local daysInYear = 365
	local years = days / daysInYear
	return years
end

function CalculationService:ConvertMonthsToSeconds(months: number): number
	local daysInMonth = 30.42 
	local seconds = months * daysInMonth * 24 * 60 * 60
	return seconds
end

function CalculationService:ConvertMonthsToMinutes(months: number): number
	local daysInMonth = 30.42
	local minutes = months	 * daysInMonth * 24 * 60
	return minutes
end

function CalculationService:ConvertMonthsToHours(months: number): number
	local daysInMonth = 30.42
	local hours = months * daysInMonth * 24
	return hours
end

function CalculationService:ConvertMonthsToDays(months: number): number
	local daysInMonth = 30.42
	local days = months * daysInMonth
	return days
end

function CalculationService:ConvertMonthsToYears(months: number): number
	local monthsInYear = 12
	local years = months / monthsInYear
	return years
end

function CalculationService:ConvertYearsToSeconds(years: number): number
	local daysInYear = 365
	local seconds = years * daysInYear * 24 * 60 * 60
	return seconds
end

function CalculationService:ConvertYearsToMinutes(years: number): number
	local daysInYear = 365 
	local minutes = years * daysInYear * 24 * 60
	return minutes
end

function CalculationService:ConvertYearsToHours(years: number): number
	local daysInYear = 365
	local hours = years * daysInYear * 24
	return hours
end

function CalculationService:ConvertYearsToDays(years: number): number
	local daysInYear = 365
	local days = years * daysInYear
	return days
end


function CalculationService:ConvertYearsToMonths(years: number): number
	local monthsInYear = 12
	local months = years * monthsInYear
	return months
end

function CalculationService:NumberToPercentage(number: number)
	local Percentage = number / 100
	return Percentage
end

function CalculationService:PercentageToNumber(percentage: number)
	local Number = percentage * 100
	return Number
end

return CalculationService
