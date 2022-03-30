class AppError < StandardError
end

class DBError < AppError
end

class DBInputError < DBError
end