--[[
	- 두 값을 쌍으로 보관하는 유틸리티
	- 타입 안전을 위해 제네릭(T, U) 사용
	- 주요 메서드:
		* getFirst() / getSecond(): 각각의 값 반환
		* toTuple(): (first, second) 튜플 반환
		* equals(other): 다른 Pair와 값 비교
		* swap(): first와 second를 뒤집은 새로운 Pair 반환

	사용 예시:
		local Pair = require(path.to.Pair)
		local p1 = Pair.new(10, "hello")
		print(p1:getFirst()) -- 10
		print(p1:getSecond()) -- "hello"
		local p2 = p1:swap()
		print(p2:getFirst()) -- "hello"
]]
