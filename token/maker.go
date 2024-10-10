package token

import "time"

type Maker interface {
	CreateToken(username string, duration time.Duration) (string, string)

	VerifyToken(token string) (*Payload, error)
}
