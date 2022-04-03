class AppError < StandardError
end

class DBError < AppError
end

class DBInputError < DBError
end

class InvalidInput < AppError
end
